extension Collection {
  public var only: Element? {
    count == 1 ? first : nil
  }
}
