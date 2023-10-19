* @ValidationCode : MjotOTI4Mzg0ODA1OkNwMTI1MjoxNjg5MzQwNjI1MTAxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:47:05
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
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.S.RTE.MARK.OTHER.PERSON(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.MARK.OTHER.PERSON
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to mark whether the person is other person for RTE form
*
* Date           ref            who                description
* 16-08-2011     New RTE Form   APAP               New RTE Form
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion            FM TO @FM, VM TO @VM, INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.T24.FUND.SERVICES

    GOSUB INIT
    GOSUB PROCESS
 
RETURN

******
INIT:
******

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.TFS = 'F.T24.FUND.SERVICES'
    F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)

    LRF.APP = "TELLER":@FM:"FUNDS.TRANSFER":@FM:"T24.FUND.SERVICES"
    LRF.FIELD = "L.RTE.FORM":@VM:"L.1ST.NAME":@FM:'L.RTE.FORM':@VM:"L.1ST.NAME":@FM:'L.RTE.FORM':@VM:"L.1ST.NAME"
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    POS.L.TT.FORM = LRF.POS<1,1>
    POS.L.TT.NAME = LRF.POS<1,2>
    POS.L.FT.FORM = LRF.POS<2,1>
    POS.L.FT.NAME = LRF.POS<2,2>
    POS.L.TFS.FORM = LRF.POS<3,1>
    POS.L.TFS.NAME = LRF.POS<3,2>

    Y.RTE.FORM = ''

RETURN

*********
PROCESS:
*********

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            R.TELLER.REC = ''
            CALL F.READ(FN.TELLER,ID.NEW,R.TELLER.REC,F.TELLER,TELLER.ERR)
            Y.RTE.FORM = R.TELLER.REC<TT.TE.LOCAL.REF,POS.L.TT.FORM>
            Y.RTE.1ST.NAME = R.TELLER.REC<TT.TE.LOCAL.REF,POS.L.TT.NAME>
        CASE ID.NEW[1,2] EQ 'FT'
            R.FT.REC = ''
            CALL F.READ(FN.FT,ID.NEW,R.FT.REC,F.FT,FT.ERR)
            Y.RTE.FORM = R.FT.REC<FT.LOCAL.REF,POS.L.FT.FORM>
            Y.RTE.1ST.NAME = R.FT.REC<FT.LOCAL.REF,POS.L.FT.NAME>
        CASE ID.NEW[1,5] EQ 'T24FS'
            R.TFS.REC = ''
            CALL F.READ(FN.TFS,ID.NEW,R.TFS.REC,F.TFS,TFS.ERR)
            Y.RTE.FORM = R.TFS.REC<TFS.LOCAL.REF,POS.L.TFS.FORM>
            Y.RTE.1ST.NAME = R.TFS.REC<TFS.LOCAL.REF,POS.L.TFS.NAME>
    END CASE

*    IF Y.RTE.FORM EQ 'YES' THEN
*        Y.OUT = 'NO'
*    END ELSE
*        Y.OUT = 'SI'
*    END

    IF Y.RTE.1ST.NAME NE '' THEN
        Y.OUT = 'NO'
    END ELSE
        Y.OUT = 'SI'
    END

RETURN

END
