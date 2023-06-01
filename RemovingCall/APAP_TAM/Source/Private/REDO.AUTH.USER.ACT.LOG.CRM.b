* @ValidationCode : Mjo3MjQxMDk0NTk6Q3AxMjUyOjE2ODIzMTYxMTk5ODI6SVRTUzotMTotMTo2NDU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:31:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 645
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.AUTH.USER.ACT.LOG.CRM
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at Auth Routine for the Following
* versions of REDO.ISSUE.CLAIMS,PROCESS , REDO.ISSUE.CLAIMS,SPECIAL , REDO.ISSUE.REQUESTS,PROCESS , REDO.ISSUE.REQUESTS,SPECIAL & REDO.ISSUE.COMPLAINTS,PROCESS
* It is used to delete the values in the REDO.USER.ACT.LOG.CRM table when the user is commiting the record.
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.AUTH.USER.ACT.LOG.CRM
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO               REFERENCE         DESCRIPTION
* 08-09-2011     Sudharsanan S      PACS00115273    Initial Creation.
* 21.04.2023     Conversion Tool       R22            Auto Conversion     - VM TO @VM, FM TO @FM
* 21.04.2023     Shanmugapriya M       R22            Manual Conversion   - No changes
*
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.REDO.USER.ACT.LOG.CRM
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------
    FN.REDO.ISSUE.CLAIMS='F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

    FN.REDO.ISSUE.REQUESTS = 'F.REDO.ISSUE.REQUESTS'
    F.REDO.ISSUE.REQUESTS = ''
    CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)

    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)

    FN.REDO.USER.ACT.LOG.CRM = 'F.REDO.USER.ACT.LOG.CRM'
    F.REDO.USER.ACT.LOG.CRM = ''
    CALL OPF(FN.REDO.USER.ACT.LOG.CRM,F.REDO.USER.ACT.LOG.CRM)

    VAR.USER = OPERATOR ; FLAG = ''

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
* This is the main para used to check and update the REDO.USER.AUT.LOG.CRM table
    GOSUB GET.VALUES
    GOSUB GET.APP.VALUES
    GOSUB UPDATE.USER.ACT.LOG.CRM
RETURN
*---------------------------------------------------------------------------------------
GET.VALUES:
*----------------------------------------------------------------------------------------
*This para is used to get the values of REDO.USER.AUT.LOG.CRM for the current user
    CALL F.READ(FN.REDO.USER.ACT.LOG.CRM,VAR.USER,R.USER.ACT.LOG.CRM,F.REDO.USER.ACT.LOG.CRM,USER.ERR)
    Y.CASE.ID=R.USER.ACT.LOG.CRM<USER.ACT.CASE.ID>
    Y.CASE.TYPE=R.USER.ACT.LOG.CRM<USER.ACT.CASE.TYPE>
    Y.CUST.ID=R.USER.ACT.LOG.CRM<USER.ACT.CUSTOMER.ID>
    Y.DATE =R.USER.ACT.LOG.CRM<USER.ACT.DATE>
    CHANGE @VM TO @FM IN Y.CASE.ID
    FM.CNT = DCOUNT(Y.CASE.ID,@FM)
RETURN
*----------------------------------------------------------------------------------------
GET.APP.VALUES:
*---------------------------------------------------------------------------------------
*This para is used to get the TYPE and CUSTOMER.CODE field values based on application
    BEGIN CASE
        CASE APPLICATION EQ 'REDO.ISSUE.CLAIMS'
            VAR.CASE.TYPE = R.NEW(ISS.CL.TYPE)
            VAR.CUST.CODE = R.NEW(ISS.CL.CUSTOMER.CODE)
        CASE APPLICATION EQ 'REDO.ISSUE.REQUESTS'
            VAR.CASE.TYPE = R.NEW(ISS.REQ.TYPE)
            VAR.CUST.CODE = R.NEW(ISS.REQ.CUSTOMER.CODE)
        CASE APPLICATION EQ 'REDO.ISSUE.COMPLAINTS'
            VAR.CASE.TYPE = R.NEW(ISS.COMP.TYPE)
            VAR.CUST.CODE = R.NEW(ISS.COMP.CUSTOMER.CODE)
    END CASE
RETURN
*---------------------------------------------------------------------------------------
UPDATE.USER.ACT.LOG.CRM:
*-----------------------------------------------------------------------------------------
    IF FM.CNT EQ '1' THEN
        CALL F.DELETE(FN.REDO.USER.ACT.LOG.CRM,VAR.USER)
    END ELSE
        GOSUB CHECK.EXISTING.VALUES
    END
RETURN
*--------------------------------------------------------------------------------------------------------------
CHECK.EXISTING.VALUES:
*---------------------------------------------------------------------------------------------------------------
*Delete the values from the table
    CNT = 1
    LOOP
    WHILE CNT LE FM.CNT
        LOCATE ID.NEW IN Y.CASE.ID,CNT SETTING POS1 THEN
            IF TODAY EQ Y.DATE<1,POS1> THEN
                IF VAR.CASE.TYPE EQ Y.CASE.TYPE<1,POS1> THEN
                    GOSUB DELETE.VALUES.LOG
                    CNT = FM.CNT+1 ;  FLAG = 1
                END
            END
            IF NOT(FLAG) THEN
                CNT = POS1+1
            END
        END ELSE
            CNT = FM.CNT+1
        END
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------------------
DELETE.VALUES.LOG:
*------------------------------------------------------------------------------------------------------------
*This para is used to delete the values in REDO.USER.ACT.LOG.CRM table
    DEL R.USER.ACT.LOG.CRM<USER.ACT.CASE.ID,POS1>
    DEL R.USER.ACT.LOG.CRM<USER.ACT.CASE.TYPE,POS1>
    DEL R.USER.ACT.LOG.CRM<USER.ACT.CUSTOMER.ID,POS1>
    DEL R.USER.ACT.LOG.CRM<USER.ACT.DATE,POS1>
    CALL F.WRITE(FN.REDO.USER.ACT.LOG.CRM,VAR.USER,R.USER.ACT.LOG.CRM)
RETURN
*--------------------------------------------------------------------------------------------------------------
END
