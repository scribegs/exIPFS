%{
  configs: [
    %{
      name: "default",
      files: %{
        include: ["lib/"],
        exclude: []
      }
    },
    checks: [
      {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 120}
    ]
  ]
}
