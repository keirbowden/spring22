public virtual with sharing class ConfigAccessor implements ClassInfoIF 
{
    public virtual String getDescription()
    {
        return 'Accessor superclass for configuration data';
    }

    public virtual String getAuthor()
    {
        return 'Bob Buzzard';
    }
}