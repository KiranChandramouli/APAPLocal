* @ValidationCode : MjoyNjgyOTAyMDE6Q3AxMjUyOjE2ODA3NzI4MjA2OTk6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:50:20
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
SUBROUTINE REDO.INP.UPD.STAFF.CUST
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.INP.UPD.STAFF.CUST
*--------------------------------------------------------------------------------
* Description: This is Input routine attached to VERSION.CONTROL>CUSTOMER to check
* whether the user involved in transaction is related to that record
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO          REFERENCE            DESCRIPTION
* 08-Apr-2011   H GANESH      PACS00023964 - N.22   INITIAL CREATION
* 14.09.2011    S Sudharsanan PACS000127814        Comment few lines(52-60) in the routine based on issue.
*----------------------------------------------------------------------------
*Modification History
*DATE                     WHO                         REFERENCE                    DESCRIPITION
*06-04-2023           Conversion Tool          R22 Auto Code conversion      VM TO @VM , ++ TO +=1
*06-04-2023            Samaran T                Manual R22 Code Conversion    No Changes
*-----------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS

    GOSUB INIT
    GOSUB PROCESS
RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.EMPLOYEE.ACCOUNTS = 'F.REDO.EMPLOYEE.ACCOUNTS'
    F.REDO.EMPLOYEE.ACCOUNTS = ''
    CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)

    FN.USER='F.USER'
    F.USER=''
    CALL OPF(FN.USER,F.USER)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    IF R.NEW(EB.CUS.FAX.1)<1,1> NE '' THEN
*PACS000127814 - S
*R.FAX.USER=''
*Y.USER = R.NEW(EB.CUS.FAX.1)<1,1>
*CALL F.READ(FN.USER,Y.USER,R.FAX.USER,F.USER,USER.ERR)
*IF R.FAX.USER EQ '' THEN
*AF = EB.CUS.FAX.1
*ETEXT = 'EB-USER.NOT.VALID'
*CALL STORE.END.ERROR
*RETURN
*END
*PACS000127814 - E
        GOSUB CHECK.EMPLOYEE
    END
    GOSUB GET.LOGGEDIN.USER

    Y.REL.CUST = R.NEW(EB.CUS.REL.CUSTOMER)
    Y.REL.CODE = R.NEW(EB.CUS.RELATION.CODE)
    Y.REL.CUS.CNT=DCOUNT(Y.REL.CUST,@VM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.REL.CUS.CNT
        Y.CUS.ID=Y.REL.CUST<1,Y.VAR1>
        CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.REL.CUST,F.CUSTOMER,CUS.ERR)
        IF R.REL.CUST<EB.CUS.FAX.1,1> EQ OPERATOR THEN
            IF Y.REL.CODE<1,Y.VAR1> EQ 13 THEN
                AF=EB.CUS.REL.CUSTOMER
                AV=Y.VAR1
                ETEXT = 'EB-USER.NOT.ALLOW.CUST'
                CALL STORE.END.ERROR
            END ELSE
                CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),@VM) + 1
                TEXT = 'USER.REL.TO.EMP'
                CALL STORE.OVERRIDE(CURR.NO)
            END
        END
        LOCATE Y.CUS.ID IN Y.EMP.REL.CUS<1,1> SETTING POS THEN
            CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),@VM) + 1
            TEXT = 'USER.REL.TO.EMP'
            CALL STORE.OVERRIDE(CURR.NO)
        END
        Y.VAR1 += 1
    REPEAT
    LOCATE ID.NEW IN Y.EMP.REL.CUS<1,1> SETTING POS THEN
        CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),@VM) + 1
        TEXT = 'USER.REL.TO.EMP'
        CALL STORE.OVERRIDE(CURR.NO)
    END


RETURN
*---------------------------------------------------------------------------------
CHECK.EMPLOYEE:
*---------------------------------------------------------------------------------

    IF OPERATOR EQ R.NEW(EB.CUS.FAX.1) THEN
        AF = EB.CUS.FAX.1
        ETEXT = 'EB-USER.NOT.ALLOW.CUST'
        CALL STORE.END.ERROR
        GOSUB END1
    END
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
*------------
END1:
*------------
END
