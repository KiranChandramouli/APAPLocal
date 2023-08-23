<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjoxMTQ3NTIxMjk3OkNwMTI1MjoxNjkwMjczMjE0MTU2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 13:50:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : MjotMTA4NzA2NDY5NjpDcDEyNTI6MTY4NDg1NDM4NzgwNTpJVFNTOi0xOi0xOjg4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 886
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.INT.CALC.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.B.INT.CALC.LOAD
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251                 Initial Creation
* 27-02-12         Shekar          Performance
*            1. CDD is not required for every transaction.. now moved to .LOAD
<<<<<<< Updated upstream
<<<<<<< Updated upstream
* Date                  who                   Reference
=======
* Date                  who                   Reference              
>>>>>>> Stashed changes
=======
* Date                  who                   Reference              
>>>>>>> Stashed changes
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - VM TO @VM
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.LIMIT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT.DEBIT.INT
    $INSERT I_F.GROUP.DEBIT.INT
    $INSERT I_F.REDO.INTEREST.REVERSE
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_REDO.B.INT.CALC.COMMON
    GOSUB OPEN.FILE
    GOSUB PROCESS

RETURN

OPEN.FILE:
*Opening Files

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT.DEBIT.INT = 'F.ACCOUNT.DEBIT.INT'
    F.ACCOUNT.DEBIT.INT = ''
    CALL OPF(FN.ACCOUNT.DEBIT.INT,F.ACCOUNT.DEBIT.INT)

    FN.GROUP.DEBIT.INT = 'F.GROUP.DEBIT.INT'
    F.GROUP.DEBIT.INT = ''
    CALL OPF(FN.GROUP.DEBIT.INT,F.GROUP.DEBIT.INT)

    FN.INTEREST.BASIS = 'F.INTEREST.BASIS'
    F.INTEREST.BASIS = ''
    CALL OPF(FN.INTEREST.BASIS,F.INTEREST.BASIS)

    FN.REDO.INTEREST.REVERSE = 'F.REDO.INTEREST.REVERSE'
    F.REDO.INTEREST.REVERSE = ''
    CALL OPF(FN.REDO.INTEREST.REVERSE,F.REDO.INTEREST.REVERSE)

    FN.REDO.APAP.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.PARAM = ''
    CALL OPF(FN.REDO.APAP.PARAM,F.REDO.APAP.PARAM)

    FN.REDO.W.ACCOUNT.UPDATE = 'F.REDO.W.ACCOUNT.UPDATE'
    F.REDO.W.ACCOUNT.UPDATE = ''
    CALL OPF(FN.REDO.W.ACCOUNT.UPDATE,F.REDO.W.ACCOUNT.UPDATE)


    aGdiIDs=''
    aGdiRecId=''

RETURN

PROCESS:

    LOC.APPLICATION = 'ACCOUNT'
*    LOC.FIELDS = 'L.AC.TRANS.INT':VM:'L.AC.TRANS.LIM':VM:'L.AC.TRANS.UTIL'

    LOC.FIELDS = 'L.AC.TRANS.INT':@VM:'L.AC.TRANS.LIM'
    LOC.POS = ''

    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    LOC.TRANS.INT.POS = LOC.POS<1,1>
    LOC.TRANS.LIM.POS = LOC.POS<1,2>
*    LOC.TRANS.UTIL.POS = LOC.POS<1,3>

    CALL CACHE.READ(FN.REDO.W.ACCOUNT.UPDATE,'SYSTEM',R.REDO.W.ACCOUNT.UPDATE,Y.ERR)
    CALL CACHE.READ(FN.REDO.APAP.PARAM,'SYSTEM',R.REDO.APAP.PARAM,PARAM.ERR)

* Getting the Dates Difference

    Y.DATE1 = TODAY
    Y.DATE2 = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    Y.NO.OF.DAYS = "C"
    CALL CDD('',Y.DATE1,Y.DATE2,Y.NO.OF.DAYS)


RETURN
END
