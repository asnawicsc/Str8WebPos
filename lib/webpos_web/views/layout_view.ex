defmodule WebposWeb.LayoutView do
  use WebposWeb, :view

  def header(header, small) do
    raw(
      Phoenix.View.render_to_string(
        WebposWeb.LayoutView,
        "header.html",
        header: header,
        small: small
      )
    )
  end
end
