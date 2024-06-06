import org.json.JSONArray;

import javax.swing.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Objects;

public class Main {

    //При неподходящих аргументах программы вывести сообщение о правильном использовании
    private static void showUsageMessage() {
        JLabel lbl = new JLabel("""
                <html>Использование программы:<br><br>
                <i>CustomLauncher.jar "ПУТЬ_ДО_JSON_ФАЙЛА"</i></html>""");

        JOptionPane.showMessageDialog(null, lbl, "Использование программы", JOptionPane.INFORMATION_MESSAGE);
    }

    public static void main(String[] args) {
        try {
            //Если аргументов нет - неправильное использование программы
            if (args.length == 0) {
                showUsageMessage();
                return;
            }

            JSONArray argsJsonArray;
            //Загрузить данные лаунчера из json файла
            argsJsonArray = new JSONArray(Files.readString(Path.of(args[0]), StandardCharsets.UTF_8));

            LaunchOption[] launchOptions = LaunchOption.fromJSON(argsJsonArray);
            JComboBox<LaunchOption> launchOptionsComboBox = new JComboBox<>(launchOptions);

            final JComponent[] inputs = new JComponent[]{
                    new JLabel("Выберите способ запуска:"),
                    launchOptionsComboBox
            };

            int selectedOption = JOptionPane.showConfirmDialog(null, inputs, "Выбор способа запуска", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

            if (selectedOption != JOptionPane.OK_OPTION) {
                return;
            }

            if (launchOptionsComboBox.getSelectedIndex() == -1) {
                return;
            }

            //Запустить программу выбранного варианта запуска
            LaunchOption selectedLaunchOption = (LaunchOption) launchOptionsComboBox.getSelectedItem();
            Objects.requireNonNull(selectedLaunchOption).launch();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,
                    "<html>Во время работы программы возникло исключение:<br><br>" +
                            "<i>" + e + "</i></html>", "Исключение", JOptionPane.ERROR_MESSAGE);
        }
    }
}