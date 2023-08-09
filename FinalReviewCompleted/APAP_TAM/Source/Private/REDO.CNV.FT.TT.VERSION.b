* @ValidationCode : MjotMzQwMzk5MDQ6Q3AxMjUyOjE2OTAxNzYwNTY4MjE6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:50:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE			               AUTHOR			Modification                            DESCRIPTION
*13/07/2023	               CONVERSION TOOL     AUTO R22 CODE CONVERSION			        FM to @FM
*13/07/2023	               VIGNESHWARI  	    MANUAL R22 CODE CONVERSION		          NOCHANGE
*-----------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.CNV.FT.TT.VERSION
* This routine is used to populate the descrptions
*------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.USER
    $INSERT I_F.T24.FUND.SERVICES
*-------------------------------------------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------

    LREF.APP = 'FUNDS.TRANSFER':@FM:'TELLER':@FM:'T24.FUND.SERVICES'
    LREF.FIELDS = 'L.ACTUAL.VERSIO':@FM:'L.ACTUAL.VERSIO':@VM:'T24.FS.REF':@FM:'L.T24FS.TRA.DAY'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    LOC.FT.VER.POS     = LREF.POS<1,1>
    LOC.TT.VER.POS     = LREF.POS<2,1>
    LOC.TT.TFS.REF.POS = LREF.POS<2,2>
    LOC.TFS.VER.POS    = LREF.POS<3,1>
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

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.FT.HIS= 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''
    CALL OPF(FN.FT.HIS,F.FT.HIS)

    FN.TFS = 'F.T24.FUND.SERVICES'
    F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)

    FN.TFS.HIS= 'F.T24.FUND.SERVICES$HIS'
    F.TFS.HIS = ''
    CALL OPF(FN.TFS.HIS,F.TFS.HIS)


RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------
    Y.CONT.ID = O.DATA
    Y.ID = Y.CONT.ID[1,2]

    BEGIN CASE

        CASE Y.ID EQ 'FT'

            R.FT = ''
            CALL F.READ(FN.FT,Y.CONT.ID,R.FT,F.FT,FT.ERR)
            IF NOT(R.FT) THEN
                CALL EB.READ.HISTORY.REC(F.FT.HIS,Y.CONT.ID,R.FT,FT.HIS.ERR)
            END

            Y.VERSION.NAME = R.FT<FT.LOCAL.REF,LOC.FT.VER.POS>


        CASE Y.ID EQ 'TT'
            R.TELLER = ''

            CALL F.READ(FN.TELLER,Y.CONT.ID,R.TELLER,F.TELLER,TT.ERR)

            IF NOT(R.TELLER) THEN
                CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.CONT.ID,R.TELLER,TT.HIS.ERR)
            END

            TFS.ID = R.TELLER<TT.TE.LOCAL.REF,LOC.TT.TFS.REF.POS>

            IF NOT(TFS.ID) THEN

                Y.VERSION.NAME = R.TELLER<TT.TE.LOCAL.REF,LOC.TT.VER.POS>

            END ELSE

                R.TFS = ''
                CALL F.READ(FN.TFS,TFS.ID,R.TFS,F.TFS,TFS.ERR)
                IF NOT(R.TFS) THEN
                    CALL EB.READ.HISTORY.REC(F.TFS.HIS,TFS.ID,R.TFS,TFS.HIS.ERR)
                END

                Y.VERSION.NAME = R.TFS<TFS.LOCAL.REF,LOC.TFS.VER.POS>

            END

        CASE 1
            Y.VERSION.NAME = ''

    END CASE

    O.DATA = Y.VERSION.NAME
RETURN
*--------------------------------------------------------------
END
