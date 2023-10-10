* @ValidationCode : MjotMTgxODEzOTE2MDpDcDEyNTI6MTY4MTEzNTE2NTMyMzpJVFNTOi0xOi0xOi04OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 19:29:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.LB.COLLECT.SELECT
*
* ====================================================================================
*
*    - Selects records from REDO.FI.LB.BPROC.DET TABLE
*
* ====================================================================================
* Subroutine Type : Multithreaded ROUTINE - SELECT
* Attached to     : REDO.FI.COLLECT service
* Attached as     : Service
* Primary Purpose : Apply payments reported in APAP-Planillas
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 26, 2010
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
*
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.FI.LB.BPROC
*
*************************************************************************
*

    GOSUB PROCESS


RETURN
*
* ======
PROCESS:
* ======
    IF CONTROL.LIST EQ '' THEN
        CALL OCOMO('Running BNK/REDO.FI.PLANILLA.COLLECT to apply PAYMENTS reported in APAP-Planillas')
        CONTROL.LIST = 'BATCH.PROCESS':@FM:'PROCESS.DET':@FM:'BALANCE.ADJUST'
    END

    YACTION = CONTROL.LIST<1,1>

    SEL.CMD = ''

    BEGIN CASE
        CASE YACTION EQ 'BATCH.PROCESS'
            GOSUB VALID.BATCH  ;*R22 interface Unit testing changes
            CALL BATCH.BUILD.LIST(LIST.PARAM,PLANILLA.LIST)
            
        CASE YACTION EQ 'PROCESS.DET'
*R22 interface Unit testing changes - START
            GOSUB VALID.BATCH
            IF Y.PARAM.IDS EQ '' THEN
                RETURN
            END
*R22 interface Unit testing changes - END
        
            Y.SEL.CMD = "SELECT ":FN.REDO.FI.LB.BATCH.PROCESS.DET: " WITH ( "
            LOOP
                REMOVE Y.PARAM.ID FROM Y.PARAM.IDS SETTING Y.POS.FILE
            WHILE Y.PARAM.ID:Y.POS.FILE
                PARAM.TXN.ID = FIELD(Y.PARAM.ID,'.',1):'.': FIELD(Y.PARAM.ID,'.',2)
                Y.SEL.CMD = Y.SEL.CMD: " @ID LIKE '":PARAM.TXN.ID:"...' OR"
            REPEAT
            Y.SEL.CMD = Y.SEL.CMD[1,LEN(Y.SEL.CMD)-2]
            Y.SEL.CMD := " ) AND WITH ESTADO EQ 'NO PAGO' AND EXCLUYO NE 'SI'"
            CALL EB.READLIST(Y.SEL.CMD,PLANILLA.LIST,"",NO.OF.REC,YER.SEL)
            CALL BATCH.BUILD.LIST(LIST.PARAM,PLANILLA.LIST)

        CASE YACTION EQ 'BALANCE.ADJUST'
            Y.SEL.CMD = "SELECT " : FI.QUEUE.PATH
            CALL EB.READLIST(Y.SEL.CMD,PLANILLA.LIST,"",NO.OF.REC,YER.SEL)
            CALL BATCH.BUILD.LIST(LIST.PARAM,PLANILLA.LIST)

    END CASE

RETURN
*R22 interface Unit testing changes- START
VALID.BATCH:
    Y.SEL.CMD = "SELECT " : FI.QUEUE.PATH
    CALL EB.READLIST(Y.SEL.CMD,PLANILLA.LIST,"",NO.OF.REC,YER.SEL)
    Y.PARAM.IDS = PLANILLA.LIST
RETURN
*R22 interface Unit testing changes - END

END
