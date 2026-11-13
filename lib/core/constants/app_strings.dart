class AppStrings {
  static const String appName = 'Gerenciador de Tarefas';

  // Tela de login
  static const String loginTitle = 'Bem-vindo de volta!';
  static const String loginSubtitle = 'Entre na sua conta para continuar';
  static const String email = 'E-mail';
  static const String password = 'Senha';
  static const String loginButton = 'Entrar';
  static const String loggingIn = 'Entrando...';

  // Validação dos campos
  static const String emailRequired = 'Informe seu e-mail';
  static const String emailInvalid = 'Informe um e-mail válido';
  static const String passwordRequired = 'Informe sua senha';
  static const String taskTitleInvalid =
      'Informe um título com pelo menos 2 caracteres';

  // Mensagens de autenticação
  static const String loginError = 'Não foi possível realizar o login';
  static const String invalidCredentials = 'E-mail ou senha incorretos';

  // Tela de adicionar tarefa
  static const String addTaskTitle = 'Adicionar tarefa';
  static const String addTaskSubtitle = 'Preencha os dados de sua nova tarefa';
  static const String saveTask = 'SALVAR TAREFA';
  static const String saveTaskError = 'Erro ao salvar tarefa';

  // Tela de editar tarefa
  static const String editTaskTitle = 'Editar tarefa';
  static const String editTaskSubtitle = 'Altere as informações de sua tarefa';
  static const String saveChanges = 'SALVAR ALTERAÇÕES';
  static const String updateTaskError = 'Erro ao atualizar tarefa';
  static const String completedTask = 'Tarefa concluída';

  // Campos de tarefas
  static const String taskTitle = 'Título da tarefa';
  static const String taskDescription = 'Descrição da tarefa';
  static const String dueDate = 'Data de vencimento';
  static const String selectDate = 'Selecionar data';
  static const String category = 'Categoria';
  static const String selectCategory = 'Selecione uma categoria';
  static const String tags = 'Etiquetas';

  // Mensagens de categorias e etiquetas
  static const String categoriesLoadError = 'Erro ao carregar categorias';
  static const String tagsLoadError = 'Erro ao carregar etiquetas';
  static const String noTags = 'Nenhuma etiqueta cadastrada.';

  // Tela de listagem de tarefas
  static const String tasksTitle = 'Minhas Tarefas';
  static const String tasksSubtitle = 'Organize e acompanhe suas atividades';
  static const String addTaskButton = '+ ADICIONAR TAREFA';
  static const String noTasks = 'Nenhuma tarefa cadastrada.';
  static const String tasksLoadError = 'Erro ao carregar tarefas';
  static const String noDescription = 'Sem descrição';
  static const String categoryPrefix = 'Categoria';
  static const String dueDatePrefix = 'Vencimento';
  static const String completed = 'Concluída';
  static const String pending = 'Pendente';
  static const String edit = 'Editar';
  static const String delete = 'Excluir';
  static const String deleteTaskTitle = 'Excluir tarefa';
  static const String deleteTaskQuestion = 'Deseja realmente excluir a tarefa';
  static const String cancel = 'Cancelar';
  static const String taskDeleted = 'Tarefa excluída com sucesso!';
  static const String deleteTaskError = 'Erro ao excluir tarefa';

  // Dashboard
  static const String dashboardGreeting = 'Olá, usuário';
  static const String dashboardSubtitle =
      'Organize suas tarefas e acompanhe seu progresso';
  static const String totalTasks = 'Total de tarefas';
  static const String pendingTasks = 'Tarefas pendentes';
  static const String completedTasks = 'Tarefas concluídas';
  static const String viewMyTasks = 'VER MINHAS TAREFAS';
}
