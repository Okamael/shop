class AuthExceptions {
  static const Map<String, String> erros = {
    'EMAIL_EXISTS': 'Email já cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente mais tarde',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado',
    'INVALID_PASSWORD': 'Senha informada não confere',
    'USER_DISABLED': 'A conta do usuário foi  desabiltiada.',
  };
  final String key;

  AuthExceptions(this.key);

  @override
  String toString() {
    // TODO: implement toString
    return erros[key] ?? 'Ocorreu um erro no processo de autenticação';
  }
}
