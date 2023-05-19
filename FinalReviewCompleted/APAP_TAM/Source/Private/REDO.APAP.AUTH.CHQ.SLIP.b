* @ValidationCode : Mjo0NTQ4NzA0ODU6Q3AxMjUyOjE2ODQ0OTEwMjczOTg6SVRTUzotMTotMToyODM6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 283
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.APAP.AUTH.CHQ.SLIP
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Temenos Development
*  Program   Name    :REDO.APAP.AUTH.CHQ.SLIP
***********************************************************************************
*Description:    This is an input routine attached to the Enquiry used
*                to PRINT a deal slip when the User clicks on PRINT option
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*15-10-2011       JEEVA T                   B.34             Initial Description
*03-01-2012      Sudharsanan S              PACS00172834     Modified Code
****************************************************************************
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $INSERT I_F.REDO.ADMIN.CHEQUE.DETAILS
    $INSERT I_F.REDO.APAP.H.REPRINT.CHQ

    GOSUB INIT

RETURN

****
INIT:
*****
    FN.REDO.ADMIN.CHEQUE.DETAILS = 'F.REDO.ADMIN.CHEQUE.DETAILS'
    F.REDO.ADMIN.CHEQUE.DETAILS = ''

    CALL OPF(FN.REDO.ADMIN.CHEQUE.DETAILS,F.REDO.ADMIN.CHEQUE.DETAILS)

    CALL F.READ(FN.REDO.ADMIN.CHEQUE.DETAILS,ID.NEW,R.REDO.ADMIN.CHEQUE.DETAILS,F.REDO.ADMIN.CHEQUE.DETAILS,Y.ERR)
    IF PGM.VERSION EQ ',REPRINT' THEN
        IF OFS$OPERATION EQ 'PROCESS' THEN
            R.NEW(REDO.REP.CHQ.REPRINT.SEQ) = R.NEW(REDO.REP.CHQ.REPRINT.SEQ) + 1
            R.NEW(REDO.REP.CHQ.REPRINT.FLAG) = ''
            R.NEW(REDO.REP.CHQ.OVERRIDE) = ''
            Y.DATA = ""
            CALL BUILD.USER.VARIABLES(Y.DATA)
            Y.CAN.VAL = FIELD(Y.DATA,'*',2)
            VEROPR ="ENQ REPORT.LIST @ID EQ ":Y.CAN.VAL
            R.REDO.ADMIN.CHEQUE.DETAILS<REDO.AD.CHQ.APPROVAL> = ''
            IF VEROPR THEN
                CALL EB.SET.NEW.TASK(VEROPR)
            END
            CALL F.WRITE (FN.REDO.ADMIN.CHEQUE.DETAILS,ID.NEW,R.REDO.ADMIN.CHEQUE.DETAILS)
        END
    END ELSE
*PACS00172834 - S
        CURR.NO = 0
        CALL STORE.OVERRIDE(CURR.NO)
        VAR.REPRINT.FLAG = R.NEW(REDO.REP.CHQ.REPRINT.FLAG)
        IF OFS$OPERATION EQ 'PROCESS' AND VAR.REPRINT.FLAG EQ 'YES' THEN
            GOSUB PROC
        END
    END

RETURN
*----------
PROC:
*----------
    VAR.CHQ.REF = R.REDO.ADMIN.CHEQUE.DETAILS<REDO.AD.CHQ.CHEQ.NO.REF>
    TEXT = "REDO.CHQ.REPRINT.OVR":@FM:VAR.CHQ.REF
    CALL STORE.OVERRIDE(CURR.NO)
*PACS00172834 - E
RETURN
*------------------------------------------------------------------------------------------------------------------------
END
