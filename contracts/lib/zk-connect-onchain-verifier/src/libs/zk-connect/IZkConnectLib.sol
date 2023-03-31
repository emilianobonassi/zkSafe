interface IZkConnectLib {
  error ZkConnectResponseIsEmpty();
  error AppIdMismatch(bytes16 receivedAppId, bytes16 expectedAppId);
  error NamespaceMismatch(bytes16 receivedNamespace, bytes16 expectedNamespace);
}
