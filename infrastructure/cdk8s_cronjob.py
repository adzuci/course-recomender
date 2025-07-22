from constructs import Construct
from cdk8s import App, Chart
from imports.k8s import KubeCronJob

class SyncCronJobChart(Chart):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)

        KubeCronJob(self, 'sync-courses',
            spec={
                'schedule': '0 * * * *',
                'jobTemplate': {
                    'spec': {
                        'template': {
                            'spec': {
                                'containers': [{
                                    'name': 'sync-courses',
                                    'image': 'python:3.9',
                                    'command': ['python', '/app/sync-courses.py'],
                                    'env': [
                                        # Add env vars for LMS/Algolia endpoints
                                    ]
                                }],
                                'restartPolicy': 'OnFailure'
                            }
                        }
                    }
                }
            }
        )

app = App()
SyncCronJobChart(app, "sync-cronjob")
app.synth() 