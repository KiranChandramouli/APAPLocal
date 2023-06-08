* @ValidationCode : Mjo0NjgwMTE4NjpDcDEyNTI6MTY4NjIyMzYxODMzNTpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Jun 2023 16:56:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date       Author                  Modification Description
* 08-06-2023   Santosh         R22 Auto Conversion - Changed FM,VM to @FM,@VM qnd corrected NEXT statement
*----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.VAL.ACC.OWNER
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT

    GOSUB INITIAL
    GOSUB PROCESS

INITIAL:
**----------------------------------------
**ABRIR LA TABLA FBNK.REDO.CUST.PRD.LIST
**----------------------------------------
    FN.CUS.PRD = "F.REDO.CUST.PRD.LIST"
    FV.CUS.PRD = ""
    R.CUS.PRD = ""
    CUS.PRD.ERR = ""

**---------------------------------------
**TABLA FBNK.JOINT.CONTRACTS.XREF
**---------------------------------------
    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF';
    FV.JOINT.CONTRACTS.XREF=''
    R.JOINT.CONTRACTS.XREF = ""
    JOINT.CONTRACTS.XREF.ERR = ""
    CALL OPF(FN.JOINT.CONTRACTS.XREF,FV.JOINT.CONTRACTS.XREF)

**----------------------------------------
**TABLA PRESTAMOS TODOS
**---------------------------------------

    FN.REDO.CUSTOMER.ARRANGEMENT='F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT=''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)


**---------------------------------------
**ABRIR LA TABLA AA.ARRANGEMENT
**---------------------------------------
    FN.AA.ARR = "F.AA.ARRANGEMENT"
    FV.AA.ARR = ""
    R.AA.ARR = ""
    AA.ARR.ERR = ""
    CALL OPF(FN.AA.ARR, FV.AA.ARR)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    CALL OPF (FN.ACCOUNT,F.ACCOUNT)

RETURN

PROCESS:

    Y.ERROR = 'NO PUEDE INGRESAR CUENTA PROPIA'

    Y.ACCOUNT = COMI

    Y.CUSTOMER  = R.NEW(ARC.BEN.OWNING.CUSTOMER)

    CALL F.READ(FN.CUS.PRD,Y.CUSTOMER,R.CUS.PRD, FV.CUS.PRD, CUS.PRD.ERR)
    Y.CUS.PRD = R.CUS.PRD<PRD.PRODUCT.ID>

    Y.CAN.CUS.PRD = DCOUNT(Y.CUS.PRD,@VM)

    FOR P = 1 TO Y.CAN.CUS.PRD STEP 1

        Y.ACC.NO = Y.CUS.PRD<1,P>

        LOCATE Y.ACC.NO IN Y.ACCOUNT SETTING POS.XREF THEN
**-------------------------------------------------------------------------------------
***MDP-1452
            Y.RELATION = 'NO'
            CALL F.READ (FN.ACCOUNT,Y.ACC.NO, R.ACCOUNT, F.ACCOUNT, ERROR.ACCOUNT)
            Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER>
            Y.JOINT.HOLDER = CHANGE(Y.JOINT.HOLDER,@SM,@FM)
            Y.JOINT.HOLDER = CHANGE(Y.JOINT.HOLDER,@VM,@FM)

            IF R.ACCOUNT<AC.CUSTOMER> EQ Y.CUSTOMER THEN
                Y.RELATION = 'YES'
            END

            LOCATE  Y.CUSTOMER IN Y.JOINT.HOLDER<1> SETTING POS.ACC THEN
                Y.RELATION = 'YES'
            END

            IF Y.RELATION EQ 'NO' THEN
                CONTINUE
            END

**----------------------------------------------------------------------------------------
            MESSAGE = Y.ERROR
            E = MESSAGE
            ETEXT = E
            CALL ERR

            RETURN

        END

    NEXT P


    CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.CUSTOMER,R.JOINT.CONTRACTS.XREF,FV.JOINT.CONTRACTS.XREF,EF.ERR)

    NO.OF.JOINT.ACCOUNT = DCOUNT(R.JOINT.CONTRACTS.XREF,@FM)

    FOR A = 1 TO NO.OF.JOINT.ACCOUNT STEP 1

        Y.ACC.NO = R.JOINT.CONTRACTS.XREF<A>

        LOCATE Y.ACC.NO IN Y.ACCOUNT SETTING POS.XREF THEN

**-------------------------------------------------------------------------------------
***MDP-1452
            Y.RELATION = 'NO'
            CALL F.READ (FN.ACCOUNT,Y.ACC.NO, R.ACCOUNT, F.ACCOUNT, ERROR.ACCOUNT)
            Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER>
            Y.JOINT.HOLDER = CHANGE(Y.JOINT.HOLDER,@SM,@FM)
            Y.JOINT.HOLDER = CHANGE(Y.JOINT.HOLDER,@VM,@FM)

            IF R.ACCOUNT<AC.CUSTOMER> EQ Y.CUSTOMER THEN
                Y.RELATION = 'YES'
            END

            LOCATE  Y.CUSTOMER IN Y.JOINT.HOLDER<1> SETTING POS.ACC THEN
                Y.RELATION = 'YES'
            END

            IF Y.RELATION EQ 'NO' THEN
                CONTINUE
            END
**----------------------------------------------------------------------------------------

            MESSAGE = Y.ERROR
            E = MESSAGE
            ETEXT = E
            CALL ERR

            RETURN

        END

*    NEXT P
    NEXT A ;*R22 Manual Conversion

**BUSCA PRESTAMOS FALTANTES

    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER,R.CUS.ARR,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)

    Y.OWNER = R.CUS.ARR<CUS.ARR.OTHER.PARTY>
    Y.CUS.ARR = CHANGE(Y.CUS.PRD,@VM,@FM)
    Y.OWNER.CNT = DCOUNT(Y.OWNER,@VM)

    FOR B = 1 TO Y.OWNER.CNT STEP 1

        Y.ACC.PR = Y.OWNER<1,B>

        CALL F.READ(FN.AA.ARR,Y.ACC.PR,R.AA.ARR,FV.AA.ARR,AA.ARR.ERR)

        Y.ACCOUNT.PR = R.AA.ARR<AA.ARR.LINKED.APPL.ID>

        LOCATE Y.ACCOUNT.PR IN Y.ACCOUNT SETTING POS.XREF THEN

            MESSAGE = Y.ERROR
            E = MESSAGE
            ETEXT = E
            CALL ERR

            RETURN

        END

    NEXT B

RETURN

END
