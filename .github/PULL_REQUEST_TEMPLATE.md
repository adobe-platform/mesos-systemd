Greetings and thanks for the PR.  We have a few rules so that everyone enjoys your Pull Request.

## Changelog

## Notes

You must explain how any `docker run` executions your PR introduces handles log accumulation. 

Any docker containers introduced through your commit must not accumulate logs in an unsustainable manner.  In other words, no unmanaged logs that aren't/can't be rotated.  

If your PR relies on the default docker log driver, `json`, then this simply means ensuring all `docker run` commands are decorated with either/both of `--log-opt max-size=XX` / `--log-opt max-file=YY` (see the docker documentation for valid XX/YY values)


Did you introduce any command that executes `docker run`?

If you did, have you ensured that all your `docker run` using the default logger have either `max-size` and/or `max-file` set?

Are there any dependencies on github.com/adobe-platform/infrastructure?

If so:
 
Is an update to the base stack required(rare)?

Is an A/B required?

Are you dependent on new secrets, or infrastructure in any way?




