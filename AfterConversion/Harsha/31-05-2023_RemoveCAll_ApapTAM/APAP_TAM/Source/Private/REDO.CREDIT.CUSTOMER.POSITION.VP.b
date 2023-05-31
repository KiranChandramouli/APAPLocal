* @ValidationCode : MjotNzk5ODkzODU1OkNwMTI1MjoxNjg1NTM0MDA4MDQ5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:23:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CREDIT.CUSTOMER.POSITION.VP(DATA.RECORD)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.04.2013
* Description  : Routine for obtaining Credit Card Information
* Type         : NOFILE Routine
* Attached to  : ENQUIRY > AI.REDO.CREDIT.CUSTOMER.POSITION.CHANGE
* Dependencies :
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, I TO I.VAR, FM TO @FM, New condition added
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY

    $INSERT I_System
    $INSERT I_ENQUIRY.COMMON
    $USING APAP.REDOCHNLS

    DEFFUN REDO.S.GET.USR.ERR.MSG()

* </region>

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
    FN.EB.EXTERNAL.USER = 'F.EB.EXTERNAL.USER'
    F.EB.EXTERNAL.USER = ''
    R.EB.EXTERNAL.USER = ''

* TODO
    FN.REDO.EB.USER.PRINT.VAR = 'F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR = ''

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''

    Y.ERR = ''

    EXT.USER.ID = ''
    CUSTOMER.ID = ''

RETURN

***********************
* Open Files
OPEN.FILES:
***********************
    CALL OPF(FN.EB.EXTERNAL.USER, F.EB.EXTERNAL.USER)

* TODO
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR, F.REDO.EB.USER.PRINT.VAR)
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

RETURN

***********************
* Main Process
PROCESS:
***********************
    EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN      ;** R22 Auto Conversion - Start
        EXT.USER.ID = ""
    END                                     ;** R22 Auto Conversion - End

    IF EXT.USER.ID NE "EXT.EXTERNAL.USER" THEN
        CALL CACHE.READ(FN.EB.EXTERNAL.USER, EXT.USER.ID, R.EB.EXTERNAL.USER, Y.ERR)
        ARR.ID = R.EB.EXTERNAL.USER<EB.XU.ARRANGEMENT>
        Y.GET.USR.TYPE = R.EB.EXTERNAL.USER<EB.XU.LOCAL.REF>

        IF INDEX(Y.GET.USR.TYPE,'CORP',1) THEN
            GOSUB GET.ARR.INFO
        END ELSE
            CUSTOMER.ID = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>
        END
    END ELSE
        LOCATE 'CLIENT.ID' IN D.FIELDS SETTING Y.POS THEN
            CUSTOMER.ID = D.RANGE.AND.VALUE<Y.POS>
        END
    END

    IF NOT(CUSTOMER.ID) THEN
        ENQ.ERROR<1> = REDO.S.GET.USR.ERR.MSG('ST-VP-ERR.CUST.REG')
*APAP.TAM.AI.REDO.KILL.SESSION ;** R22 Manual conversion - CALL method format changed

        APAP.REDOCHNLS.aiRedoKillSession() ;*R22 Manual Conversion
    END ELSE
        GOSUB INVOKE.VP.WS.CXC
    END

RETURN

GET.ARR.INFO:

    Y.SEL.CMD = 'SELECT ':FN.AA.ARRANGEMENT.ACTIVITY:' WITH ARRANGEMENT EQ ':ARR.ID
    CALL EB.READLIST(Y.SEL.CMD,Y.SEL.LIST,'',NO.OF.RECS,'')
    IF Y.SEL.LIST THEN
        LOOP
            REMOVE Y.SEL.ID FROM Y.SEL.LIST SETTING Y.SEL.POS
        WHILE Y.SEL.ID:Y.SEL.POS
            IF INDEX(Y.SEL.ID,'-',1) ELSE

                CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.SEL.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ERR.ARR)
                Y.GET.FIELD.NAME = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.FIELD.NAME>
                LOCATE 'ALLOWED.CUSTOMER:1:1' IN Y.GET.FIELD.NAME<1,1,1> SETTING YF.POS THEN
                    CUSTOMER.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.FIELD.VALUE,1,YF.POS>
                END
            END
        REPEAT
    END
RETURN

**************************************************
* Invoke VP Web Service 'CONSOLIDADO_X_CLIENTE'
INVOKE.VP.WS.CXC:
**************************************************
    ACTIVATION = 'WS_T24_VPLUS'

    WS.DATA = ''
    WS.DATA<1> = 'CONSOLIDADO_X_CLIENTE'
    WS.DATA<2> = CUSTOMER.ID

* Invoke VisionPlus Web Service
*  APAP.REDOCHNLS.REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA) ;** R22 Manual conversion - CALL method format changed
    APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA) ;*R22 Manual Conversion
    
    BEGIN CASE
        CASE WS.DATA<1> EQ 'OK'
            GOSUB SET.ENQ.DATA
        CASE 1  ;* 'ERROR' - 'OFFLINE'
            ENQ.ERROR<1> = WS.DATA<2>
    END CASE

RETURN

*******************
* Set Enquiry Data
SET.ENQ.DATA:
*******************
    CHANGE "*" TO @VM IN WS.DATA
    Y.TIPO.PRODUCTO = WS.DATA<2>
    Y.CC.NUM = DCOUNT(Y.TIPO.PRODUCTO,@VM) - 1

    FOR I.VAR = 1 TO Y.CC.NUM    ;** R22 Auto conversion - I TO I.VAR
        CUST.DATA = ''
* Numero_Plastico
        CCARD.NUM = FIELD(WS.DATA<4>,@VM,I.VAR)       ;** R22 Auto conversion - I TO I.VAR
        CCARD.NUM = CCARD.NUM[4,LEN(CCARD.NUM)]
        CUST.DATA<5> = CCARD.NUM
* Balance_total_RD
        CUST.DATA<10> = FIELD(WS.DATA<7>,@VM,I.VAR)     ;** R22 Auto conversion - I TO I.VAR
* Tipo_producto
        CUST.DATA<11> = FIELD(WS.DATA<2>,@VM,I.VAR)      ;** R22 Auto conversion - I TO I.VAR
* Balance_DisponibleRD
        CUST.DATA<12> = FIELD(WS.DATA<9>,@VM,I.VAR)      ;** R22 Auto conversion - I TO I.VAR
* Balance_Total_US
        CUST.DATA<13> = FIELD(WS.DATA<8>,@VM,I.VAR)       ;** R22 Auto conversion - I TO I.VAR
* Balance_DisponibleUS
        CUST.DATA<15> = FIELD(WS.DATA<10>,@VM,I.VAR)      ;** R22 Auto conversion - I TO I.VAR

** Remaining fields from WS Invocation not used
* NUMERO_CUENTA
        CACCT.NUM = FIELD(WS.DATA<3>,@VM,I.VAR)          ;** R22 Auto conversion - I TO I.VAR
        CACCT.NUM = CACCT.NUM[4,LEN(CACCT.NUM)]
        CUST.DATA<16> = CACCT.NUM

* FECHA_APERTURA
* CUST.DATA<17> = FIELD(WS.DATA<5>,VM,I)
* FECHA_ULT_PAGO
* CUST.DATA<18> = FIELD(WS.DATA<6>,VM,I)

        CHANGE @FM TO "*" IN CUST.DATA
        DATA.RECORD<-1> = CUST.DATA

* Temporal - Para mantener la sesion entre enquiries
* Borrar cuando finalice todo el refactoring de rutinas de ARC-IB
        CUSTOMER.CARD.LIST<-1> = CCARD.NUM
    NEXT I.VAR       ;** R22 Auto conversion - I TO I.VAR

* Temporal - Para mantener la sesion entre enquiries
* Borrar cuando finalice todo el refactoring de rutinas de ARC-IB
    CALL System.setVariable("CURRENT.CARD.LIST.CUS", CUSTOMER.CARD.LIST)
    REDO.EB.USER.PRINT.VAR.ID = EXT.USER.ID : "-" : "CURRENT.CARD.LIST.CUS"

*PACS00540091-FIX START*
    R.REDO.EB.USER.PRINT.VAR=''
    R.REDO.EB.USER.PRINT.VAR.ERR=''
* Read a Dummy record.
    CALL F.READU(FN.REDO.EB.USER.PRINT.VAR,REDO.EB.USER.PRINT.VAR.ID,R.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR,REDO.EB.USER.PRINT.VAR.ERR,'')
* Write the Customer Card List as per existing code.
    CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,REDO.EB.USER.PRINT.VAR.ID,CUSTOMER.CARD.LIST)
*    WRITE CUSTOMER.CARD.LIST TO F.REDO.EB.USER.PRINT.VAR, REDO.EB.USER.PRINT.VAR.ID
*PACS00540091-FIX END*
    CALL JOURNAL.UPDATE("")

RETURN

* </region>

END
