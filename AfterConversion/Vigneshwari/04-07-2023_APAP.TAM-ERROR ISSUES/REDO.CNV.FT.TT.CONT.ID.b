* @ValidationCode : MjotODMxMjI5OTYyOkNwMTI1MjoxNjg4NDU4MDUxMTExOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jul 2023 13:37:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*04/07/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*04/07/2023         VIGNESHWARI      MANUAL R22 CODE CONVERSION           'I_F.T24.FUND.SERVICES' insert file is commanded
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CNV.FT.TT.CONT.ID
* This routine is used to populate the contract id for FT,TT,TFS
*------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.USER
*   $INSERT I_F.T24.FUND.SERVICES
*-------------------------------------------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------

    LREF.APP = 'TELLER'
    LREF.FIELDS = 'T24.FS.REF'
    LOC.TT.TFS.REF.POS = ''
    CALL GET.LOC.REF(LREF.APP,LREF.FIELDS,LOC.TT.TFS.REF.POS)

RETURN
*--------------------------------------------------------------
OPENFILES:
*--------------------------------------------------------------
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)

RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------
    Y.CONT.ID = O.DATA

    Y.CONTRACT.ID = O.DATA

    Y.ID = Y.CONT.ID[1,2]

    BEGIN CASE

        CASE Y.ID EQ 'FT'

            O.DATA = Y.CONTRACT.ID

        CASE Y.ID EQ 'TT'
            R.TELLER = ''

            CALL F.READ(FN.TELLER,Y.CONT.ID,R.TELLER,F.TELLER,TT.ERR)

            IF NOT(R.TELLER) THEN
                CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.CONT.ID,R.TELLER,TT.HIS.ERR)
            END

            TFS.ID = R.TELLER<TT.TE.LOCAL.REF,LOC.TT.TFS.REF.POS>

            IF NOT(TFS.ID) THEN

                O.DATA = Y.CONTRACT.ID

            END ELSE

                O.DATA = TFS.ID

            END

    END CASE

RETURN
*--------------------------------------------------------------
END
