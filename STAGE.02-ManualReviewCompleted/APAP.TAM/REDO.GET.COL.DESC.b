* @ValidationCode : MjotNzUyODQwNDQwOkNwMTI1MjoxNjgxMTExODc4NDcxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:01:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.GET.COL.DESC

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.COLLATERAL.CODE
    $INSERT I_ENQUIRY.COMMON


    Y.VAL.1 = O.DATA
    Y.VAL = FIELD(Y.VAL.1,'-',1)

    FN.COL.CODE = 'F.COLLATERAL.CODE'
    F.COL.CODE = ''
    CALL OPF(FN.COL.CODE,F.COL.CODE)

    FN.COL = 'F.COLLATERAL'
    F.COL = ''
    CALL OPF(FN.COL,F.COL)

    CALL MULTI.GET.LOC.REF('COLLATERAL','L.COL.PRO.DESC2',POLS)

    IF Y.VAL EQ '350' OR Y.VAL EQ '450' THEN
        Y.ID = FIELD(Y.VAL.1,'-',2)
        CALL F.READ(FN.COL,Y.ID,R.COL,F.COL,COL.ERR)
        Y.NM.VAL = R.COL<COLL.LOCAL.REF,POLS>
    END ELSE
        CALL F.READ(FN.COL.CODE,Y.VAL,R.VAL,F.COL.CODE,CD.ERR)
        Y.NM.VAL = R.VAL<COLL.CODE.DESCRIPTION,2>
        IF Y.NM.VAL EQ '' THEN
            Y.NM.VAL = R.VAL<COLL.CODE.DESCRIPTION,1>
        END
    END

    O.DATA = Y.NM.VAL

RETURN

END
