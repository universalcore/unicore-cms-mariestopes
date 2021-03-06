from datetime import datetime
from pyramid import testing

from cms.tests.base import UnicoreTestCase
from unicorecmsmariestopes import main
from unicore.content.models import Page, Localisation, Category


class TestViews(UnicoreTestCase):

    def setUp(self):
        self.workspace = self.mk_workspace()
        settings = {
            'git.path': self.workspace.working_dir,
            'git.content_repo_url': '',
            'es.index_prefix': self.workspace.index_prefix,
            'cache.enabled': 'false',
            'cache.regions': 'long_term, default_term',
            'cache.long_term.expire': '1',
            'cache.default_term.expire': '1',
            'pyramid.default_locale_name': 'eng_GB',
            'thumbor.security_key': 'sample-security-key',
        }
        self.config = testing.setUp(settings=settings)
        self.app = self.mk_app(self.workspace, settings=settings, main=main)

    def test_homepage_page(self):
        self.workspace.setup_custom_mapping(Category, {
            'properties': {
                'slug': {
                    'type': 'string',
                    'index': 'not_analyzed',
                },
                'language': {
                    'type': 'string',
                    'index': 'not_analyzed'
                }
            }
        })
        self.workspace.setup_custom_mapping(Page, {
            'properties': {
                'slug': {
                    'type': 'string',
                    'index': 'not_analyzed',
                },
                'language': {
                    'type': 'string',
                    'index': 'not_analyzed'
                }
            }
        })
        self.workspace.setup_custom_mapping(Localisation, {
            'properties': {
                'locale': {
                    'type': 'string',
                    'index': 'not_analyzed',
                }
            }
        })

        [category] = self.create_categories(
            self.workspace,
            count=1)
        self.create_localisation(
            self.workspace,
            image='some-uuid',
            image_host='http://some.site.com')
        [intro_page] = self.create_pages(
            self.workspace,
            count=1,
            title='foo title',
            description='foo description',
            created_at=datetime.utcnow().isoformat(),
            primary_category=category.uuid)

        resp = self.app.get('/', status=200)
        self.assertTrue(
            'http://some.site.com/VNlJN07VKnfaB6k1imziAts4n0o='
            '/320x0/some-uuid' in
            resp.body)
        self.assertIn('foo title', resp.body)
        self.assertIn('foo description', resp.body)
