* @ValidationCode : MjotMTgwNDA1Mzk2NzpDcDEyNTI6MTY4MTA1NjQ4NjAxODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:06
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.SET.RESTRICT.DATA
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to create a table RESTRICT LIST
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 23-08-2011        Prabhu.N         PACS00075748         Initial Creation
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - M TO @FM, VM TO @VM, ++ TO += 1
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS

    GOSUB OPEN.FILES
    GOSUB GET.CURRENT.USER
    GOSUB PROCESS


RETURN
*-------------------------------------------
OPEN.FILES:
*-------------------------------------------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.REDO.EMPLOYEE.ACCOUNTS = 'F.REDO.EMPLOYEE.ACCOUNTS'
    F.REDO.EMPLOYEE.ACCOUNTS = ''
    CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)

    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF=''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

RETURN
*-------------------------------------------
GET.CURRENT.USER:
*-------------------------------------------

    SEL.CMD='SELECT ':FN.CUSTOMER:' WITH FAX.1 EQ ':OPERATOR
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.CUR.CUS.ID  = SEL.LIST
    CHANGE @FM TO ' ' IN Y.CUR.CUS.ID

RETURN

*-------------------------------------------
PROCESS:
*-------------------------------------------
    IF Y.CUR.CUS.ID THEN
        SEL.CMD.EMP = 'SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS:' WITH @ID NE ':Y.CUR.CUS.ID
    END ELSE
        SEL.CMD.EMP = 'SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS
    END
    SEL.CUS.EMP = ''
    CALL EB.READLIST(SEL.CMD.EMP,SEL.CUS.EMP,'',SEL.NOR.CUS,SEL.RET)
    IF SEL.CUS.EMP THEN
        GOSUB GET.ACCOUNTS
    END

    CHANGE @FM TO ' ' IN Y.ACC.IDS
    CALL System.setVariable("INT.SMS.ACCOUNT",Y.ACC.IDS)

RETURN
*-------------------------------------------
GET.ACCOUNTS:
*-------------------------------------------
    Y.ACC.IDS = ''
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE SEL.NOR.CUS
        Y.CUS.ID   = SEL.CUS.EMP<Y.VAR1>
        CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.ID,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,CUS.ACC.ERR)
        R.CUS.ACC  =R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.ACCOUNT>
        CHANGE @VM TO @FM IN R.CUS.ACC
        Y.ACC.IDS<-1> = R.CUS.ACC
        Y.VAR1 += 1          ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
END
