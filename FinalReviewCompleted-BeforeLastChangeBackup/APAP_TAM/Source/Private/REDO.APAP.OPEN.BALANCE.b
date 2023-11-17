* @ValidationCode : MjoxMzA4MDk4NjpDcDEyNTI6MTY4MjMxNjExOTY1NzpJVFNTOi0xOi0xOjc4MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:31:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 780
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.APAP.OPEN.BALANCE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CON.GET.TIME
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Conversion routine is used to fetch the amount from STMT.ENTRY Application
*
*Linked With       : ENQ REDO.AZ.DYNAMIC.REPORT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who             Reference                                 Description
*     ------         -----           -------------                             -------------
*   29 09 2010   Jeyachandran S    ODR-2010-03-0166                            Initial Creation
*   21.04.2023   Conversion Tool       R22                                  Auto Conversion     - FM TO @FM, F TO CACHE, ++ TO += 1
*   21.04.2023   Shanmugapriya M       R22                                  Manual Conversion   - No changes
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT.CLASS


    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB GOEND
RETURN

*----------------
OPENFILES:

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.STMT.PRINTED = 'F.STMT.PRINTED'
    F.STMT.PRINTED = ''
    CALL OPF(FN.STMT.PRINTED,F.STMT.PRINTED)

    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    F.ACCOUNT.CLASS  = ''
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)
RETURN

*------------
PROCESS:


    Y.ID = O.DATA
    CALL F.READ(FN.ACCOUNT,Y.ID,R.ACCOUNT,F.ACCOUNT,F.ERR)
    ACCT.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    Y.ACCT.CLASS = 'SAVINGS'
    CALL CACHE.READ(FN.ACCOUNT.CLASS, Y.ACCT.CLASS, R.ACCT.CLASS, CLASS.ERR)           ;** R22 Auto conversion - F TO CACHE
    Y.SAVINGS.CATEGORY = R.ACCT.CLASS<AC.CLS.CATEGORY>
    LOCATE ACCT.CATEGORY IN Y.SAVINGS.CATEGORY<1,1> SETTING CATEGORY.POS THEN
        ACT.FLAG = '1'
    END
    IF ACT.FLAG EQ '1' THEN
        IF R.ACCOUNT NE '' THEN
            Y.OPEN.DATE = R.ACCOUNT<AC.OPENING.DATE>
            D.FIELDS = 'ACCOUNT':@FM:'BOOKING.DATE'
            D.LOGICAL.OPERANDS = '1':@FM:'9'
            D.RANGE.AND.VALUE = Y.ID:@FM:Y.OPEN.DATE
            Y.ID.LIST = ''
            CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)
            Y.CNT = DCOUNT(Y.ID.LIST,@FM)
            Y.INIT = 1
            LOOP
            WHILE Y.INIT LE Y.CNT
                Y.NAME = FIELD(Y.ID.LIST,@FM,Y.INIT)
                Y.AMT = FIELD(Y.NAME,'*',7)
                IF Y.AMT GT 0 THEN
                    O.DATA = Y.AMT
                    GOSUB GOEND
                END ELSE
                    O.DATA = 0.00
                END
                Y.INIT + =1
            REPEAT
        END
    END ELSE
        O.DATA = 0.00
    END
    IF ACT.FLAG EQ '1' THEN
        IF R.ACCOUNT EQ '' THEN
            SEL.CMD = "SELECT ":FN.STMT.PRINTED: " WITH @ID LIKE ":Y.ID:"..."
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOF,ERR)
            CALL F.READ(FN.STMT.PRINTED,SEL.LIST,R.STMT.PRINTED,F.STMT.PRINTED,ERR1)
            Y.CNT = DCOUNT(R.STMT.PRINTED,@FM)
            Y.START = 1
            LOOP
            WHILE Y.START LE Y.CNT
                Y.STMT.ID = R.STMT.PRINTED<Y.START>
                CALL F.READ(FN.STMT.ENTRY,Y.STMT.ID,R.STMT.REC,F.STMT.ENTRY,ERR2)
                Y.AMT = R.STMT.REC<AC.STE.AMOUNT.LCY>
                IF Y.AMT GT 0 THEN
                    BREAK
                END ELSE
                    Y.START += 1                   ;** R22 Auto conversion - ++ TO += 1
                END
            REPEAT
            O.DATA = Y.AMT
        END ELSE
            O.DATA = 0.00
        END
    END ELSE
        O.DATA = 0.00
    END
RETURN
*--------
GOEND:
END
