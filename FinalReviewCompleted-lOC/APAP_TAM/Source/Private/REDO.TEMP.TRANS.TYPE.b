* @ValidationCode : MjotOTcwMTA3Nzc6Q3AxMjUyOjE2ODQ0OTEwNDA2ODg6SVRTUzotMTotMTo0MDA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 400
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TEMP.TRANS.TYPE
*-----------------------------------------------------------------------------

* This is conversion routine attached with the enquiry REDO.DISB.E.AUTH.ARR to
* display the description of the transaction type.

* Reference : PACS00240923
* Developed  By : Marimuthus@temenos.com
* Date : 01-02-2013
*------------------------------------------------------------------------------

* Revision History:
*------------------
* Date          who                  Reference       Description
* 06-Jun-2017       Edwin Charles D  R15 Upgrade         Initial Creation
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FC.TEMP.DISB
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_ENQUIRY.COMMON

    FN.REDO.FT.TT.TRANSACTION.NAU = 'F.REDO.FT.TT.TRANSACTION$NAU'
    F.REDO.FT.TT.TRANSACTION.NAU = ''
    CALL OPF(FN.REDO.FT.TT.TRANSACTION.NAU,F.REDO.FT.TT.TRANSACTION.NAU)

    FN.REDO.FC.TEMP.DISB = 'F.REDO.FC.TEMP.DISB'
    F.REDO.FC.TEMP.DISB = ''
    CALL OPF(FN.REDO.FC.TEMP.DISB,F.REDO.FC.TEMP.DISB)

    Y.ID = O.DATA
    CALL F.READ(FN.REDO.FT.TT.TRANSACTION.NAU,Y.ID,R.REDO.FT.TT.TRANSACTION,F.REDO.FT.TT.TRANSACTION.NAU,REDO.FT.ERR)
    Y.ACT.VER = R.REDO.FT.TT.TRANSACTION<FT.TN.L.ACTUAL.VERSIO>

    BEGIN CASE

        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.OTI' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.PART.OTI'
            Y.FC = 'APERTURA.DEP'
        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.CHEQUE' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.PART.CHEQUE'
            Y.FC = 'CHEQUE'
        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.ACDP' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.PART.ACDP'
            Y.FC = 'CR.CTA'
        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.CASH' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.PART.CASH'
            Y.FC = 'EFECTIVO'
        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.MULTI.AA.ACCRAP.DISB' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.MULTI.AA.ACCRAP.PDISB'
            Y.FC = 'PAGO.PR'
        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.LTCC' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.PART.LTCC'
            Y.FC = 'PAGO.TARJ'
        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.IB.ACH' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.PART.IB.ACH'
            Y.FC = 'TRANSFERENCIA'
        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.MULTI.AA.ACRP.DISB' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.MULTI.AA.PART.ACRP.DISB'
            Y.FC = 'PAGO.CAP.PREST'
        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.INTERBRANCH.ACH' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.PART.INTERBRANCH.ACH'
            Y.FC = 'TRANSF.TESORERIA'
        CASE Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.MULTI.AA.ACPOAP.DISB' OR Y.ACT.VER EQ 'REDO.FT.TT.TRANSACTION,REDO.MULTI.AA.PART.ACPOAP.DISB'
            Y.FC = 'CANC.PRESTAMO'

    END CASE

    IF Y.FC THEN
        CALL F.READ(FN.REDO.FC.TEMP.DISB,Y.FC,R.REDO.TEMP.DISB,F.REDO.FC.TEMP.DISB,FC.ERR)
        O.DATA = R.REDO.TEMP.DISB<FC.TD.DESCRIPCION>
    END ELSE
        O.DATA = ''
    END

RETURN

END
