namespace :user_flowchart do
  desc "Generates SVG flowchart from the mermaid document"
  task "generate_svg" do
    sh "mmdc -i plan/user_flowchart.mmd -o plan/user_flowchart.svg"
  end
end
