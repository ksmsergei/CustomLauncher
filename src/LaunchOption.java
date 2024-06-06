import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;

//Вариант запуска для лаунчера
public class LaunchOption {
    private String displayedName;
    private String command;
    private String[] args;

    private LaunchOption() {
        displayedName = null;
        command = null;
        args = new String[0];
    }

    public LaunchOption(String displayedName, String command) {
        this.displayedName = displayedName;
        this.command = command;
        args = new String[0];
    }

    public LaunchOption(String displayedName, String command, String ... args) {
        this.displayedName = displayedName;
        this.command = command;
        this.args = args;
    }

    //Получить LaunchOption из JSON объекта
    public static LaunchOption fromJSON(JSONObject jsonObject) {
        LaunchOption launchOption = new LaunchOption();
        launchOption.displayedName = jsonObject.getString("name");
        launchOption.command = jsonObject.getString("command");

        if (jsonObject.has("args")) {
            JSONArray argsJsonArray = jsonObject.getJSONArray("args");
            launchOption.args = new String[argsJsonArray.length()];
            for (int i = 0; i < argsJsonArray.length(); i++) {
                launchOption.args[i] = argsJsonArray.getString(i);
            }
        }

        return launchOption;
    }

    //Получить массив LaunchOption из JSON массива
    public static LaunchOption[] fromJSON(JSONArray jsonArray) {
        LaunchOption[] launchOptions = new LaunchOption[jsonArray.length()];

        for (int i = 0; i < jsonArray.length(); i++) {
            launchOptions[i] = fromJSON(jsonArray.getJSONObject(i));
        }

        return launchOptions;
    }

    //Запустить программу текущего варианта запуска
    public void launch() {
        //Первый аргумент - сама программа, а остальные - дополнительные аргументы командной строки
        String[] allArgs = new String[args.length + 1];
        allArgs[0] = command;
        System.arraycopy(args, 0, allArgs, 1, args.length);

        ProcessBuilder processBuilder = new ProcessBuilder();
        processBuilder.command(allArgs);

        try {
            processBuilder.start();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public String getDisplayedName() {
        return displayedName;
    }

    public String getCommand() {
        return command;
    }

    public String[] getArgs() {
        return args;
    }

    @Override
    public String toString() {
        return displayedName;
    }
}