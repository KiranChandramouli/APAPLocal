* @ValidationCode : MjoyMzIwMzYyMjI6Q3AxMjUyOjE2ODU0NDQyMzk4MjE6aGFpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 May 2023 16:27:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.JAVA.RABIT.SEND(Y.DATA,Y.RETURN,Y.RABBIT,Y.ERROR)
    
*----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date       Author                  Modification Description
* 18-05-2023   Ghayathri T             R22 Manual Conversion - Changed GOTO to GOSUB
* 24-05-2023   Conversion Tool         R22 Auto Conversion - Changed $INCLUDE to $INSERT
* 24-05-2023   Conversion Tool         R22 Auto Conversion - Changed = to EQ
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*DEBUG
    Y.CLASSNAME = 't24RabbitmqSrv/t24RabbitmqSrv'
    Y.METHODNAME = '$sentToRabbitMq'
    Y.DATA.SEND = ''
    Y.RETURN = ''
    Y.ERROR = ''
    Y.SYSTEM = ''

*FM
*EXCHANGE
    Y.DATA.SEND<1> = Y.RABBIT<1>
*ROUTING KEY
    Y.DATA.SEND<2> = Y.RABBIT<2>
*QUEUE
    Y.DATA.SEND<3> = Y.RABBIT<4>
*PAYLOAD
    Y.DATA.SEND<4> = Y.DATA<1>

    CHANGE @FM TO '||' IN Y.DATA.SEND

*DEBUG
    CALLJ Y.CLASSNAME, Y.METHODNAME, Y.DATA.SEND SETTING Y.RETURN ON ERROR
        GOSUB ERR.HANDLER ;* R22 Manual conversion - Changed GOTO to GOSUB
        Y.SYSTEM = SYSTEM(0)

        CHANGE '|' TO @FM IN Y.RETURN
        IF Y.RETURN<1> EQ 'false' THEN
*DEBUG
            Y.ERROR<1> = 1
            Y.ERROR<2> = Y.RETURN<3>
            Y.ERROR<3> = Y.RETURN<5>
        END
        ELSE
            Y.ERROR<1> = 0
        END

        RETURN

ERR.HANDLER:
        Y.SYSTEM = SYSTEM(0)
        Y.ERROR<1> = 1
        Y.ERROR<3> = 'L.APAP.JAVA.RABIT.SEND'
        Y.RETURN='false'

        BEGIN CASE
            CASE Y.SYSTEM EQ 1
                Y.ERROR<2> = 'Fatal error creating thread'
            CASE Y.SYSTEM EQ 2
                Y.ERROR<2> =  "Cannot find the JVM.dll !"
            CASE Y.SYSTEM EQ 3
                Y.ERROR<2> =  "Class " : Y.CLASSNAME : "doesn't exist !"
            CASE Y.SYSTEM EQ 4
                Y.ERROR<2> = 'Unicode conversion error'
            CASE Y.SYSTEM EQ 5
                Y.ERROR<2> =  "Method " :  Y.METHODNAME : "doesn't exist !"
            CASE Y.SYSTEM EQ 6
                Y.ERROR<2> = 'Cannot find object constructor'
            CASE Y.SYSTEM EQ 7
                Y.ERROR<2> = 'Cannot instantiate object'
            CASE 1
                Y.ERROR<2> = 'SYSTEM(0)>' : Y.SYSTEM
        END CASE

        RETURN
    END
