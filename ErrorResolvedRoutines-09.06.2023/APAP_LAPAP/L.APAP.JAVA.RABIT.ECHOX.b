* @ValidationCode : Mjo3Mjk5Njc3MTpDcDEyNTI6MTY4NjI4OTQwMzU1NDpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jun 2023 11:13:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>90</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.JAVA.RABIT.ECHOX(Y.DATA,Y.RETURN,Y.ERROR)
*-----------------------------------------------------------------------------
* Modification History:
*
* Date             Who              Reference              Description
* 09.06.2023      Santos         R22 Manual Conversion     Added package and Y.RABBIY initialized
*-----------------------------------------------------------------------------
    $INCLUDE I_COMMON
    $INCLUDE I_EQUATE

*DEBUG
    Y.CLASSNAME = 't24RabbitmqSrv/t24RabbitmqSrv'
    Y.METHODNAME = '$sendEchoX'
    Y.DATA.SEND = ''
    Y.RETURN = ''
    Y.ERROR = ''
    Y.SYSTEM = ''
    Y.RABBIT = '' ;* R22 Manual Conversion - Variable initialized

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
    CALLJ Y.CLASSNAME, Y.METHODNAME, Y.DATA.SEND SETTING Y.RETURN ON ERROR GOTO ERR.HANDLER
    Y.SYSTEM = SYSTEM(0)
    Y.ERROR<1> = 0
RETURN

ERR.HANDLER:
    Y.SYSTEM = SYSTEM(0)
    Y.ERROR<1> = 1

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
