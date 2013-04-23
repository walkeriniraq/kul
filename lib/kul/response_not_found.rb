require 'kul/response'

class ResponseNotFound < Kul::Response

  HTML = <<-END_HTML
    <!DOCTYPE html>
    <html>
    <head>
      <style type="text/css">
      body { text-align:center;font-family:helvetica,arial;font-size:22px;
        color:#888;margin:20px}
      </style>
    </head>
    <body>
      <h2>Dude, what?</h2>
      <div>I have no idea what you're asking for.</div>
      <h6>404</h6>
    </body>
    </html>
  END_HTML

  def status
    404
  end

  def body
    HTML
  end
end