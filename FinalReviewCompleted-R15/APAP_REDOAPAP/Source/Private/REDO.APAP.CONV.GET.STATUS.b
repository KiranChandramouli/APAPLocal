* @ValidationCode : MjotMTk1ODQ5MTc3MjpDcDEyNTI6MTY4NDgzNjAzNjA0MjpJVFNTOi0xOi0xOjYxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 61
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CONV.GET.STATUS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.GET.STATUS
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION Routine to attach to display the STATUS of the USER based on Conditions
*
*Linked With       : Enquiry
*In  Parameter     : O.DATA
*Out Parameter     : O.DATA
*Files  Used       : USER                    As              I               Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*     28.10.2010           Mudassir V          ODR-2010-03-0095           Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPENFILE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------------------------------
*********
OPENFILE:
**********
    Y.ATTEMT.SINCE      = ''
    Y.ATTEMPTS          = ''
    Y.START.TIME        = ''
    Y.END.TIME          = ''
    Y.END.DATE.PORFILE  = ''
    Y.STATUS            = ''
    Y.FLAG              = ''
    FN.USER = 'F.USER'
    F.USER  = ''
    CALL OPF(FN.USER,F.USER)

RETURN
*-------------------------------------------------------------------------------------------------------
********
PROCESS:
********
    Y.FLAG ='F'
    Y.ATTEMT.SINCE     = R.RECORD<EB.USE.ATTEMPTS.SINCE>
    Y.ATTEMPTS         = R.RECORD<EB.USE.ATTEMPTS>
    Y.START.TIME       = R.RECORD<EB.USE.START.TIME>
    Y.END.TIME         = R.RECORD<EB.USE.END.TIME>
    Y.END.DATE.PORFILE = R.RECORD<EB.USE.END.DATE.PROFILE>

    IF Y.ATTEMT.SINCE GT Y.ATTEMPTS THEN
        Y.STATUS  = 'BLOQUEADO*IF'
        Y.FLAG  = 'T'
    END

    IF Y.START.TIME EQ 0 AND Y.END.TIME EQ 0 THEN
        IF Y.FLAG EQ 'T' THEN
            Y.STATUS : = @VM:'BLOQUEADO'
        END ELSE
            Y.STATUS  = 'BLOQUEADO'
            Y.FLAG  = 'T'
        END
    END

    IF Y.END.DATE.PORFILE LE TODAY THEN
        IF Y.FLAG EQ 'T' THEN
            Y.STATUS : = @VM:'EXPIRADO'
        END ELSE
            Y.STATUS ='EXPIRADO'
            Y.FLAG = 'T'
        END
    END

    IF Y.FLAG NE 'T' THEN
        Y.STATUS = 'ACTIVO'
    END

    LOCATE O.DATA IN Y.PROCESSED.REC SETTING POS THEN
        RETURN
*O.DATA = Y.STATUS<1,VC>
    END ELSE
        Y.PROCESSED.REC<-1> = O.DATA
        O.DATA = Y.STATUS
    END

*   VM.STAT.COUNT=DCOUNT(FIN.STATUS,VM)
*   Y.COMPANY=R.RECORD<EB.USE.COMPANY.RESTR>
*   VM.COMP.COUNT = DCOUNT(Y.COMPANY,VM)
*   IF VM.STAT.COUNT NE VM.COMP.COUNT THEN
*       BEGIN CASE
*       CASE VM.COMP.COUNT GE 3 AND VM.STAT.COUNT EQ 2

*           FIN.STATUS : = VM:' '
*           O.DATA=FIN.STATUS
*       CASE VM.COMP.COUNT GE 3 AND VM.STAT.COUNT EQ 1

*           FIN.STATUS : = VM:' ':VM:' '
*           O.DATA=FIN.STATUS
*       CASE VM.COMP.COUNT EQ 2 AND VM.STAT.COUNT EQ 1

*           FIN.STATUS : = VM:' '
*           O.DATA=FIN.STATUS
*       END CASE
*   END* O.DATA=FIN.STATUS


RETURN
*-------------------------------------------------------------------------------------------------------
END
