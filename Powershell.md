# PowerShell 기본 문법

## PowerShell의 기본 기능과 주요 cmdlet의 사용 방법

PowerShell의 모든 명령은 cmdlet(command-let)으로 이루어져 있습니다. 기본적으로 `Get-Help`, `Get-Content`, `Start-Service` 등과 같이 **동사-명사**의 형식으로 구성되어 있습니다. 이 cmdlet을 조합해 다양한 동작을 실행할 수 있습니다. 각 명령의 도움말을 보려면 `Get-Help Start-Service -full`과 같이 하면 됩니다.

PowerShell은 최초 설치 시 보안 문제 때문에 기본적으로 ps1 스크립트 파일을 실행할 수 없도록 설정되어 있습니다. 따라서 아래 명령을 통해 ps1 스크립트 파일을 실행할 수 있게 설정해야 합니다.

```powershell
PS C:\> Set-ExecutionPolicy RemoteSigned
```

> TIP
> 
> 공유 폴더에 위치한 서명되지 않은 PowerShell 스크립트를 실행하려면 다음과 같이 실행합니다.
> ```powershell
> PS C:\> Set-ExecutionPolicy Unrestricted
> ```

기존 명령 프롬프트와 마찬가지로 디렉터리 목록 보기 명령은 `dir`입니다. 하지만 PowerShell에서는 유닉스 명령인 `ls`도 지원합니다. 디렉터리 간 이동은 그대로 `cd`를 사용합니다.

```powershell
PS C:\> ls
PS C:\> cd C:\
```

시스탬 내의 모든 프로세스 목록을 볼 수 있습니다. 정규식 형태의 옵션을 사용할 수도 있습니다. 즉 `[s]*`라고 하면 s 로 시작하는 모든 프로세스를 출력합니다.

```powershell
PS C:\> Get-Process
PS C:\> Get-Process [s]*
```

레지스트리 접근도 가능합니다. 레지스트리로 이동하는 방식은 디렉토리를 이동하는 방식과 같습니다. `cd HKLM:`라고 입력하면 `HKEY_LOCAL_MACHINE`으로 이동하고, `cd HKCU:`라고 입력하면 `HKEY_CURRENT_USER`로 이동하게 됩니다. 주의할점은 실제로 HKLM이나 HKCU라는 디렉토리가 있을 수 있기 때문에, 레지스트리 HKLM, HKCU 뒤에는 `:`(콜론)을 반드시 붙여주어야 합니다.

레지스트리로 이동하게 되면 프롬프트는 **PS C:\\>** 에서  **PS HKLM:\\>** 으로 바뀌게 됩니다. `dir` 또는 `ls` 명령으로 레지스트리 키의 내부를 확인할 수 있고, `cd` 명령으로 레지스트리 키 사이를 이동할 수 있습니다.

```powershell
PS C:\> cd HKLM:
PS HKLM:\> dir
PS HKLM:\> cd SYSTEM
```

레지스트리의 값을 읽으려면 `Get-ItemProperty`, 값을 쓰려면 `Set-ItemProperty`를 사용합니다

```powershell
PS HKLM:\> Get-ItemProperty SOFTWARE\Microsoft\Windows\CurrentVersion\Run
PS HKLM:\> Set-ItemProperty HKLM:\Example -name hello -value 1
```

출력 결과를 그룹화할 수 있습니다. 아래 예제는 시스템의 전체 프로세스 중에서 프로세스 이름(ProcessName) 같은 것은 묶어서 출력해 줍니다. `|`(파이프)는 각 명령을 연결해서 하나의 명령처럼 사용할 수 있도록 해줍니다.

```powershell
PS C:\> Get-Process | Group-Object ProcessName
```

`Format-List`를 이용하면 속성을 선택적으로 출력할 수 있습니다. 아래 예제에서는 powershell 프로세스가 로드한 DLL(Modules)과 프로세스 내의 핸들을 출력해줍니다. 모든 속성을 출력하려면 `*`를 사용하면 됩니다.

```powershell
PS C:\> Get-Process powershell | Format-List Modules, Handles
PS C:\> Get-Process powershell | Format-List *
```

`Sort-Object`를 이용하여 출력 결과를 정렬할 수 있습니다. 아래 예제는 시스템의 모든 프로세스를 프로세스 ID가 작은 순서대로 정렬하여 출력합니다. `-descending` 옵션을 사용하면 프로세스 ID가 큰 순서대로 정렬하여 출력합니다.

```powershell
PS C:\> Get-Process | Sort-Object Id
PS C:\> Get-Process | Sort-Object Id -descending
```

텍스트 파일의 내용을 읽어오려면 `Get-Content`를 사용합니다. `Get-Content`에 텍스트 파일 경로를 지정하여 사용합니다.

```powershell
PS C:\> Get-Content C:\example.txt
```

변수의 내용을 텍스트 파일로 저장하려면 `Set-Content`를 사용합니다. `$text`라는 변수에 **“Hello PowerShell”** 이라는 내용을 대입한 뒤 `Set-Content`로 변수의 내용을 파일에 저장할 수 있습니다.

```powershell
PS C:\> $text = "Hello PowerShell"
PS C:\> Set-Content C:\hello.txt $text
```

`Get-Content`는 텍스트 형식 뿐만 아니라 XML 형태의 문서도 읽어올 수 있습니다. XML 문서를 XML 변수로 저장한 다음 각 엘리먼트를 손쉽게 참조할 수 있습니다. 즉 아래와 같이 XML 문서가 있습니다.

`C:\hello.xml`

```xml
<?xml version="1.0" ?>
<example>PowerShell</example>
```

이제 `Get-Content`로 XML 파일의 내용일 읽어 변수에 저장합니다. 여기서 중요한 것은 `$hello`라는 변수 앞에 `[xml]`이라고 변수 형태를 지정했다는 것입니다. 이렇게 변수가 XML 형태로 되어 있으면 해당 XML의 각 엘리먼트를 C 언어에서 구조체를 참조하듯이 참조할 수 있습니다. 아래 예제에서는 hello.xml의 \<example> 엘리먼트를 `$hello.example`과 같이 참조하고 있습니다.

```powershell
PS C:\> [xml]$hello = Get-Content C:\hello.xml
PS C:\> echo $hello.example
PowerShell
```

앞서 살펴본 `[xml]` 이외에도 변수를 `[int]`, `[string]`처럼 정수형, 문자열형 형태로 지정할 수 있습니다. 아래 예제에서처럼 `$value`에 “1”이라고 문자열을 대입했지만 `[int]`로 지정하였기 때문에 정수형이 되고 1을 더하면 2가 됩니다.

```powershell
PS C:\> [int]$value = "1"
PS C:\> $value + 1
2
```

이번에는 `[string]`을 사용하여 `$value` 변수를 문자열 형태로 지정하였습니다. 그래서 문자열 “1”에 1을 붙였기 때문에 11이 됩니다.

```powershell
PS C:\> [string]$value = "1"
PS C:\> $value + 1
11
```

COM 형태의 메서드도 호출하여 사용할 수 있습니다. 아래 예제에서는 변수 `$ie`에 인터넷 익스플로러의 Object를 생성하고 사용할 수 있는 메서드 목록을 출력합니다. 그리고 `Navigate` 메서드를 사용하여 인터넷 익스플로러를 실행합니다.

```powershell
PS C:\> $ie = New-Object -ComObject "InternetExplorer.Application"
PS C:\> $ie | Get-Member -MemberType Method
PS C:\> $ie.Navigate("http://www.pyrasis.com")
PS C:\> $ie.Visible = $true
```

WMI는 WMIC.exe(Windows Management Infrastructure Console)을 사용했었는데 PowerShell에서는 직접 사용할 수 있습니다.

```powershell
PS C:\> Get-WmiObject Win32_Processor
PS C:\> Get-WmiObject Win32_BIOS
PS C:\> Get-WmiObject Win32_PhysicalMemory
```

## PowerShell 스크립트 문법

PowerShell의 문법은 지금까지 독자들이 사용해왔던 프로그래밍 언어, 유닉스 쉘 스크립트와 비슷합니다.

- 변수

    변수는 Perl, PHP, 유닉스 쉘 스크립트와 같이 `$` 를 사용합니다. 변수 이름은 영문 및 한글을 지원하며 숫자로만 된 이름도 가능합니다. 변수에 값을 대입할 때에는 `=`을 사용하며 문자열을 대입할 때에는 `" "` 따옴표를 사용해야 합니다. 변수 앞에 `[int]`, `[char]`, `[string]`, `[xml]` 등을 사용하여 변수 형태를 강제로 지정해줄 수 있습니다.

    ```powershell
    $hello = 1
    $world = "1"
    $1234 = "hi"
    $변수 = 123
    [int]$hello = "123"
    [string]$hello = 123
    ```

- 배열

    배열은 `@`로 표현합니다. 단 배열을 저장할 때는 변수에 저장해야 하며, 아래 예제와 같이 `$array[0]`, `$array[1][1]`처럼 참조하면 됩니다.

    ```powershell
    $array = @(1,2,3,4)
    echo $array[0]
    1
    $array = @((1,2,3,4),(5,6,7,8))
    echo $array[1][1]
    6
    ```

- 산술 연산자
    
    산술 연산자는 기존의 프로그래밍 언어와 사용 방법이 거의 똑같습니다. `+` : 더하기 및 연결, `-` : 빼기, `*` : 곱하기 및 문자열 반복, `/` : 나누기, `%` : 몫입니다.

    ```powershell
    $a + $b
    $a - $b
    $a * $b
    $a / $b
    $a % $b
    ```

- 증감 연산자
    
    증감 연산자도 기존의 프로그래밍 언어와 사용방법이 거의 똑같습니다. `++` : 1 증가, `--` : 1 감소. 중요한 것은 다른 프로그래밍 언어들과 마찬가지로 이 증감 연산자가 변수 앞에 붙는지 변수 뒤에 붙는지에 따라 효과가 달라집니다.

    ```powershell
    $a = 1
    $b = $a++
    echo $b
    1
    $a = 1
    $b = ++$a
    echo $b
    2
    ```

    할당 연산자 할당 연산자는 `=` : 대입, `+=` : 더한 뒤 대입, `-=` : 뺀 뒤 대입, `/=` : 나눈 뒤 대입, `%=` : 몫을 구한 뒤 대입이 있습니다.

    ```powershell
    $a += $b
    $a -= $b
    $a *= $b
    $a /= $b
    $a %= $b
    ```

- 주석

    주석은 Perl, PHP, 유닉스 쉘 스크립트와 마찬가지로 `#`을 사용합니다. 스크립트에서 줄의 맨 앞에 `#`이 있으면 그 줄 전체가 주석이 되며, 변수나 cmdlet이 있으면서 그 뒤에 `#`이 오면 `#` 뒤에 오는 부분이 주석이 됩니다.

    ```powershell
    # 예제 주석
    $ hello = "안녕하세요" # 변수에 안녕하세요를 대입
    ```

    여러 줄을 주석으로 만들려면 `<# #>`를 사용하면 됩니다.

    ```powershell
    <#
    Get-Item C:\
    Get-Process
    #>
    Write-Host "hello"
    ```

- 비교 연산자

    PowerShell에서 비교 연산자는 다른 프로그래밍 언어나 쉘 스크립트와는 조금 다릅니다. 일반적으로 `<`, `>`를 사용하여 비교하지만 PowerShell에서는 `>`를 리다이렉션으로 사용하기 때문에 `<`, `>`를 사용하지 않고 `-eq`(같음, =), `-ne`(같지 않음, !=), `-gt`(보다 큼, >), `-ge`(보다 크거나 같음, >=), `-lt`(보다 작음, <), `-le`(보다 작거나 같음, <=)를 사용합니다.

    ```powershell
    1 -eq 2
    if ($a -lt $b) { echo $a }
    ```

- 조건문

    조건문은 기존의 프로그래밍 언어와 거의 같습니다. 단 조건문을 사용할 때 비교 연산자는 `<`, `>` 등을 사용하는 것이 아닌 위에서 설명한 `-lt`, `-gt` 등을 사용해야 합니다.

    ```powershell
    if ($a -lt $b)
    {
        echo $a
    }
    elseif ($a -eq $b)
    {
        echo $b
    }
    else
    {
        echo $a
    }
    ```

- 반복문
    
    반복문 또한 기존 프로그래밍 언어와 사용법이 거의 같습니다. `for`, `foreach`, `while`, `do while`, `do until` (`continue`, `break`)를 사용할 수 있습니다. `for`는 `for (초기화, 조건, 반복)` 형태로 사용합니다.

    ```powershell
    for ($i = 0; $i -lt 5; $i++)
    {
        echo $i
    }
    ```

    `foreach`는 `foreach ($a in $b)` 형태로 사용하는데 `$b`는 배열 형태가 되어야 합니다. `$b` 배열 안에 든 내용을 순서대로 `$a`에 대입하면서 반복하게 됩니다. `$b` 배열안에 든 데이터의 개수만큼 반복합니다.

    ```powershell
    $b = 1, 2, 3, 4, 5
    foreach ($a in $b)
    {
        echo $a
    }
    ```

    `while`은 `while (조건)` 형태로 사용합니다. `while`은 조건이 참인 동안 반복합니다.

    ```powershell
    $a = 1
    while ($a -lt 10)
    {
        echo $a
        $a++
    }
    ```

    `do while`은 `do { } while (조건)` 형태로 사용하고, `do until`은 `do {} until (조건)` 형태로 사용합니다. `do while`은 조건이 참인 동안 반복하지만 `do until`은 조건이 참이 될 때까지 반복합니다.

    ```powershell
    $a = 1
    do
    {
        echo $a
        $a++
    }
    while ($a -lt 10)
    $a = 1
    do
    {
        echo $a
        $a++
    }
    until ($a -gt 10)
    ```

    `continue`와 `break`는 조건문과 함께 사용됩니다. `continue`는 `continue` 이하 코드는 건너뛰고 루프를 다시 반복하며, `break`는 루프를 멈출 때 사용합니다.

    ```powershell
    while (1)
    {
        if ($a -lt 10)
            continue
    }
    while (1)
    {
        if ($a -gt 10)
            break
    }
    ```

- 분기문
    
    PowerShell에서 분기문은 다른 프로그래밍 언어와 마찬가지로 `switch`이며 `switch (변수)` 형태로 사용합니다.

    ```powershell
    switch ($a)
    {
        "1" { echo 1 }
        "2" { echo 2 }
        default { echo 0 }
    }
    ```

- 논리 연산자

    대부분의 프로그래밍 언어나 쉘 스크립트에서는 논리 연산자로 `&`와 `|`를 사용합니다. 하지만 PowerShell에서는 `!`, `-not`(반대), `-and`(그리고), `-or`(또는)을 사용합니다.

    ```powershell
    if (($a -eq 1) -and ($b -eq 2))
    {
        echo $a
    }
    ```

- 함수

    함수를 만들려면 `function`을 사용합니다. `function 함수명` 형태로 사용하며, 함수를 호출하려면 함수 이름 그대로 입력해주면 됩니다. 함수의 매개변수는 공백으로 구분합니다.

    ```powershell
    function MyFunction
    {
        echo "MyFunction"
        echo $args[0]
    }

    MyFunction 1
    ```

- 스크립트 및 함수의 매개변수
    
    스크립트 파일 및 함수의 매개변수는 `$args` 변수안에 저장됩니다. `$args[0]`은 첫 번째 매개변수이며 `$args[1]`은 두 번째 매개변수가 됩니다. 아래 내용을 `hello.ps1`로 저장합니다.

    `hello.ps1`

    ```powershell
    echo $args[0]
    echo $args[1]
    ```

    `hello.ps1 hello world `처럼 hello와 world를 매개변수로 지정해주면 다음과 같이 hello와 world가 출력되게 됩니다.

    ```powershell
    .\hello.ps1 hello world
    hello
    world
    ```

    함수의 매개변수도 마찬가지입니다. 아래 함수를 실행하면 hello와 world가 출력돕니다.

    ```powershell
    function HelloFunction
    {
        echo $args[0]
        echo $args[1]
    }

    HelloFunction hello world
    ```

- 스크립트 및 함수의 반환값(리턴값)
    
    `return`으로 함수의 반환값을 지정할 수 있으며 스크립트 파일 자체의 반환값도 `return`으로 지정할 수 있습니다. 아래 예제에서 `HelloFunction` 함수를 실행하면 `$a`에 `HelloFunction`의 반환값인 `100`이 대입됩니다.

    ```powershell
    function HelloFunction
    {
        return 100
    }

    $a = HelloFunction
    ```

    이번에는 스크립트 파일의 반환값을 알아보겠습니다. 다음 내용을 `hello.ps1`로 저장합니다.

    `hello.ps1`

    ```powershell
    return 100
    ```

    그리고 PowerShell 명령행이나 스크립트 파일에서 다음과 같이 `hello.ps1`을 실행하면 `$a`에 `hello.ps1`의 반환값인 `100`이 대입됩니다.

    ```powershell
    $a = hello.ps1
    ```

- 스크립트 블록

    PowerShell에서는 cmdlet을 변수에 저장한 뒤 해당 변수를 실행할 수 있습니다. cmdlet을 변수에 저장할 때에는 `{ }`를 사용하며 각 요소를 구분할 때에는 `;`(세미콜론)을 사용합니다. cmdlet이 저장된 변수를 실행하려면 변수 이름 앞에 `&`를 붙여주면 됩니다.

    ```powershell
    $hello = { Get-Process; echo 1 }
    &$hello
    ```

    다음은 PowerShell 문법을 간단하게 표로 정리한 것입니다.

    |항목|문법|예제|
    |:---:|---|---|
    |변수|`$`|`$hello`|
    |배열|`@`|`@(2), $a[2][3]`|
    |산술 연산자|`+` (더하기, 연결), `-` (빼기), <br>`*` (곱하기, 문자열 반복), `/` (나누기), `%` (몫)|`$a + $b`|
    |증감 연산자|`++` (1 증가), `-–` (1 감소)|`$a++, $b--`|
    |할당 연산자|`=`, `+=`, `-=`, `*=`, `/=`, `%=`|`$a += $b`
    |주석|`#`|`# Hello World`|
    |비교 연산자|`-eq` (같음, =), `-ne` (같지 않음, !=),<br>`-gt` (보다 큼, >), `-ge` (보다 크거나 같음, >=),<br>`-lt` (보다 작음, <), `-le` (보다 작거나 같음, <=)|`if ($a -lt 10)`|
    |조건문|`if`, `elseif`, `else`|`if ($a -eq 10)`|
    |반복문|`for`, `foreach`, `while`,<br>`do while`, `do until` (`continue`, `break`)|`for ($i = 0; $i –lt 5; $i++) { }`<br>`foreach ($a in $b) { }`<br>`while ($i -ne 10) { }`<br>`do { } while ($i -ne 10)`<br>`do { } until ($i -ne 10)`|
    |분기문|`switch`, `switch ($a)`|`{`<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`“1” { echo 1 }`<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`“2” { echo 2 }`<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`default { echo 0 }`<br>`}`|
    |논리 연산자|`!`, `-not`, `-and`, `-or`|`if (!$a)`|
    |함수|`function`|`function MyFunction`<br>`{`<br>&nbsp;&nbsp;&nbsp;&nbsp;`echo “Hello”`<br>`}`
    |스크립트 및 함수의 매개변수|`$args`|`$args[0] $args[1]`
    |스크립트 및 함수의 반환값 (리턴값)|`return`|`return $a`|
    |스크립트 블록|`&`|`$hello = { Get-Process; echo 1; }`<br>`&$hello`|