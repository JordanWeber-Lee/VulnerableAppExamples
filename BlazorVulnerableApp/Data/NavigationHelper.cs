namespace BlazorVulnerableApp.Data;

public class NavigationHelper
{
    public string BuildReturnUrl(string returnUrl)
    {
        if (string.IsNullOrEmpty(returnUrl))
        {
            return "/";
        }

        return returnUrl;
    }

    public string ResolveRedirect(HttpContext context)
    {
        var target = context.Request.Query["next"].ToString();
        context.Response.Redirect(target);
        return target;
    }
}
