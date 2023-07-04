* @ValidationCode : Mjo0Mjc3NTA0OTQ6Q3AxMjUyOjE2ODY2NzU5MTcyOTI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:35:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACCT.VAL
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ACCT.VAL
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check valid notification value
*Linked With       : ACCOUNT,REDO.ACCT.ENTR
*In  Parameter     :
*Out Parameter     :
*Files  Used       : ACCOUNT            As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 06/09/2010       NATCHIMUTHU.P            HD1029093               Initial Creation
* 06-06-2023      Conversion Tool       R22 Auto Conversion - NO CHANGE
* 06-06-2023      ANIL KUMAR B          R22 Manual Conversion - Adding AF = L.AC.NOTIFY.1 TO AV = Y.NOTIFY.POS AND adding I_REDO.B.INW.PROCESS.COMMON
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.INW.PROCESS.COMMON  ;*R22 MANUAL CONVERSION

    GOSUB INIT
    GOSUB PROCESS.PARA
RETURN

INIT:
*******
* DEBUG
    LOC.REF.APPL= "ACCOUNT"
    LOC.REF.FIELDS= "L.AC.NOTIFY.1"
    LOC.REF.POS= " "
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.NOTIFY.POS   =  LOC.REF.POS<1,1>
    Y.NOTIFY1 = R.NEW(AC.LOCAL.REF)<1,Y.NOTIFY.POS>
RETURN


PROCESS.PARA:
*************
    LOOP
        REMOVE Y.NOTIFY FROM Y.NOTIFY1 SETTING POS
    WHILE Y.NOTIFY:POS
        IF Y.NOTIFY EQ 'EMPLOYEE' OR Y.NOTIFY EQ 'TELLER' OR Y.NOTIFY EQ 'STOP.CHEQUE' OR Y.NOTIFY EQ 'RETURNED.CHEQUE' THEN
*AF = L.AC.NOTIFY.1
            AV = Y.NOTIFY.POS    ;*R22 MANUAL CONVERSION AF = L.AC.NOTIFY.1 TO AV = Y.NOTIFY.POS
            ETEXT = 'CO-MANDATORY.REMARKS'
            CALL STORE.END.ERROR
        END
    REPEAT
RETURN

END

*------------------------------------------------------------------------------------------------------
* PROGRAM END
*-------------------------------------------------------------------------------------------------------
