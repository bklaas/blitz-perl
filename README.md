## ![blitz.io](http://blitz.io/images/logo2.png)

Make load and performance testing a fun sport.

* Run a sprint from around the world
* Rush your API and website to scale it out
* Condition your site around the clock

## Getting started
Login to [blitz.io](http://blitz.io) and in the blitz bar type:
    --api-key

Now
    cpan Blitz
 
**In your Perl**
```perl
    use Blitz;

    my $blitz = Blitz->new();
```
then:
**Sprint**

```perl
$blitz->sprint({
    url => 'www.mycoolapp.com',
    region => 'california',
    callback => \&sprint_sink($ok, $err)
});

```
or:
**Rush**
```perl
$blitz->rush({
    url => 'www.mycoolapp.com',
    region => 'california',
    pattern => [
        {
            start => 1,
            end => 100,
            duration => 60,
        }],
        callback => \&rush_sink($ok, $err)
});
```
