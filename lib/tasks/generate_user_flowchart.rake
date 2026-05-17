namespace :user_flowchart do
  desc "Generates SVG flowchart from the mermaid document"
  task "generate_svg" do
    sh "mmdc -i doc/user_flowchart.mmd -o doc/user_flowchart.svg"
  end
end
