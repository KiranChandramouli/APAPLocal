* @ValidationCode : MjoxOTQ5Nzg1MTk2OkNwMTI1MjoxNjgyNDEyMzI4OTM5OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM
*05-04-2023       Samaran T             Manual R22 Code Conversion         No Changes
*-------------------------------------------------------------------------------------------
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.UPD.DEP.CASHPAYOUT
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER

    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------
    FN.REDO.DEP.CASHPAYOUT = 'F.REDO.DEP.CASHPAYOUT'
    F.REDO.DEP.CASHPAYOUT = ''

    CALL OPF(FN.REDO.DEP.CASHPAYOUT,F.REDO.DEP.CASHPAYOUT)

    L.APP = 'TELLER'
    L.FLD = 'L.TT.AZ.ACC.REF':@VM:'L.TT.CLIENT.COD'
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(L.APP,L.FLD,LRF.POS)
    L.POS = LRF.POS<1,1>
    L.CUS.POS = LRF.POS<1,2>

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    VAR.AZ.ID = R.NEW(TT.TE.LOCAL.REF)<1,L.POS>
    VAR.CUSTOMER = R.NEW(TT.TE.LOCAL.REF)<1,L.CUS.POS>

    CALL F.READ(FN.REDO.DEP.CASHPAYOUT,VAR.CUSTOMER,R.REDO.DEP.CASHPAYOUT,F.REDO.DEP.CASHPAYOUT,CASH.ERR)
    IF R.REDO.DEP.CASHPAYOUT THEN
        R.REDO.DEP.CASHPAYOUT<-1> = VAR.AZ.ID
    END ELSE
        R.REDO.DEP.CASHPAYOUT = VAR.AZ.ID
    END
    CALL F.WRITE(FN.REDO.DEP.CASHPAYOUT,VAR.CUSTOMER,R.REDO.DEP.CASHPAYOUT)

RETURN
*-----------------------------------------------------------------------------
END
*-----------------------------------------------------------------------------
