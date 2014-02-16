

 # GET home page.
 

exports.index = (req, res) ->
  res.render('index', { title: '4REAL' });

exports.partials = (req, res) ->
  name = req.params.name;
  res.render('partials/' + name);
