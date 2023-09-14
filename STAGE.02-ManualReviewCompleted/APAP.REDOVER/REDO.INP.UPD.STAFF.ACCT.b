* @ValidationCode : Mjo5MDQ1NzI3OTI6Q3AxMjUyOjE2ODA3Njk5NjUwMjY6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:02:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.UPD.STAFF.ACCT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.INP.UPD.STAFF.ACCT
*--------------------------------------------------------------------------------
* Description: This is Input routine attached to VERSION.CONTROL>ACCOUNT to check whether
* the USER inputting the transaction is related to the account.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO               REFERENCE                    DESCRIPTION
*08-Apr-2011     H GANESH           PACS00023964 - N.22          INITIAL CREATION
*06-04-2023      Conversion Tool     R22 Auto Code conversion      VM TO @VM , ++ TO +=1
*06-04-2023       Samaran T          Manual R22 Code Conversion    No Changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS

    GOSUB INIT
    GOSUB PROCESS
RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.EMPLOYEE.ACCOUNTS='F.REDO.EMPLOYEE.ACCOUNTS'
    F.REDO.EMPLOYEE.ACCOUNTS=''
    CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)


RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.CUSTOMER = R.NEW(AC.CUSTOMER)
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)

    Y.FAX.ID = R.CUSTOMER<EB.CUS.FAX.1,1>
    IF Y.FAX.ID NE '' THEN
        IF Y.FAX.ID EQ OPERATOR THEN
            AF = AC.CUSTOMER
            ETEXT = 'EB-USER.NOT.ALLOW'
            CALL STORE.END.ERROR
        END

    END

    GOSUB GET.LOGGEDIN.USER
    IF Y.CUSTOMER THEN
        LOCATE Y.CUSTOMER IN Y.EMP.REL.CUS<1,1> SETTING POS THEN
            CURR.NO = DCOUNT(R.NEW(AC.OVERRIDE),@VM) + 1
            TEXT = 'USER.REL.TO.EMP'
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
    Y.JOINT.HOLDER = R.NEW(AC.JOINT.HOLDER)
    Y.RELATION     = R.NEW(AC.RELATION.CODE)
    GOSUB CHECK.JOINT

RETURN
*---------------------------------------------------------------------------------
CHECK.JOINT:
*---------------------------------------------------------------------------------
    Y.JOINT.CNT = DCOUNT(Y.JOINT.HOLDER,@VM)

    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.JOINT.CNT
        Y.JOIN.CUS.ID = Y.JOINT.HOLDER<1,Y.VAR1>
        CALL F.READ(FN.CUSTOMER,Y.JOIN.CUS.ID,R.JOIN.CUS,F.CUSTOMER,JOINT.CUS.ERR)
        Y.JOIN.FAX.ID = R.JOIN.CUS<EB.CUS.FAX.1,1>
        IF Y.JOIN.FAX.ID EQ OPERATOR THEN
            IF Y.RELATION<1,Y.VAR1> EQ 13 THEN
                AF = AC.RELATION.CODE
                AV = Y.VAR1
            END ELSE
                CURR.NO = DCOUNT(R.NEW(AC.OVERRIDE),@VM) + 1
                TEXT = 'USER.REL.TO.EMP'
                CALL STORE.OVERRIDE(CURR.NO)
            END
        END
        IF Y.JOIN.CUS.ID THEN
            LOCATE Y.JOIN.CUS.ID IN Y.EMP.REL.CUS<1,1> SETTING POS THEN
                CURR.NO = DCOUNT(R.NEW(AC.OVERRIDE),@VM) + 1
                TEXT = 'USER.REL.TO.EMP'
                CALL STORE.OVERRIDE(CURR.NO)
            END
        END
        Y.VAR1 += 1
    REPEAT
RETURN
*---------------------------------------------------------------------------------
GET.LOGGEDIN.USER:
*---------------------------------------------------------------------------------

    SEL.CMD = 'SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS:' WITH USER.ID EQ ':OPERATOR
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.EMP.CUS.ID = SEL.LIST<1>  ;* There will be only one record for each employee
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.EMP.CUS.ID,R.EMPLOYEE.RECORD,F.REDO.EMPLOYEE.ACCOUNTS,EMP.ERR)
    Y.EMP.REL.CUS = R.EMPLOYEE.RECORD<REDO.EMP.REL.CUSTOMER>

RETURN
END
