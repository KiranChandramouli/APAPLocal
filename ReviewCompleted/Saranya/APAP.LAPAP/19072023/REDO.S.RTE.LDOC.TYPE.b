* @ValidationCode : MjotMTkxMjk5NzYyNTpDcDEyNTI6MTY4OTc0NDU3MDkxNzpJVFNTOi0xOi0xOjU4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 10:59:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 586
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE REDO.S.RTE.LDOC.TYPE(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.LDOC.TYPE
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the Document Type value
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion            FM TO @FM, VM TO @VM, INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.T24.FUND.SERVICES ;*R22 Auto Conversion - End

    GOSUB INIT
    GOSUB PROCESS
RETURN
*********
INIT:
*********

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.TFS = 'F.T24.FUND.SERVICES'
    F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)

    LOC.REF.APPL = 'TELLER':@FM:'FUNDS.TRANSFER':@FM:'T24.FUND.SERVICES'
    LOC.REF.FIELDS = 'L.ACQD.CITIZEN':@VM:'L.NEW.ID.CARD':@VM:'L.OLD.ID.CARD':@VM:'L.PASSPORT'
    LOC.REF.FIELD = LOC.REF.FIELDS:@FM:LOC.REF.FIELDS:@FM:LOC.REF.FIELDS

    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELD,LOC.POS)
    Y.TT.RNC.POS = LOC.POS<1,1>
    Y.TT.NEW.CARD.POS = LOC.POS<1,2>
    Y.TT.OLD.CARD.POS = LOC.POS<1,3>
    Y.TT.PASSPORT = LOC.POS<1,4>

    Y.FT.RNC.POS = LOC.POS<2,1>
    Y.FT.NEW.CARD.POS = LOC.POS<2,2>
    Y.FT.OLD.CARD.POS = LOC.POS<2,3>
    Y.FT.PASSPORT = LOC.POS<2,4>

    Y.TFS.RNC.POS = LOC.POS<3,1>
    Y.TFS.NEW.CARD.POS = LOC.POS<3,2>
    Y.TFS.OLD.CARD.POS = LOC.POS<3,3>
    Y.TFS.PASSPORT = LOC.POS<3,4>

RETURN
*********
PROCESS:
*********
    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            R.TELLER = ''
            TELLER.ERR = ''
            CALL F.READ(FN.TELLER,ID.NEW,R.TELLER,F.TELLER,TELLER.ERR)
            IF R.TELLER THEN
                Y.L.PASSPORT = R.TELLER<TT.TE.LOCAL.REF,Y.TT.PASSPORT>
                Y.L.ACQD.CITIZEN = R.TELLER<TT.TE.LOCAL.REF,Y.TT.RNC.POS>
                Y.L.NEW.ID.CARD = R.TELLER<TT.TE.LOCAL.REF,Y.TT.NEW.CARD.POS>
                Y.L.OLD.ID.CARD = R.TELLER<TT.TE.LOCAL.REF,Y.TT.OLD.CARD.POS>
            END

        CASE ID.NEW[1,2] EQ 'FT'
            R.FT = ''
            FT.ERR = ''

            CALL F.READ(FN.FT,ID.NEW,R.FT,F.FT,FT.ERR)
            IF R.FT THEN
                Y.L.PASSPORT = R.FT<FT.LOCAL.REF,Y.FT.PASSPORT>
                Y.L.ACQD.CITIZEN = R.FT<FT.LOCAL.REF,Y.FT.RNC.POS>
                Y.L.NEW.ID.CARD = R.FT<FT.LOCAL.REF,Y.FT.NEW.CARD.POS>
                Y.L.OLD.ID.CARD = R.FT<FT.LOCAL.REF,Y.FT.OLD.CARD.POS>
            END

        CASE ID.NEW[1,2] EQ 'TFS'
            R.TFS =  ''
            TFS.ERR = ''

            CALL F.READ(FN.TFS,ID.NEW,R.TFS,F.TFS,TFS.ERR)
            IF R.TFS THEN
                Y.L.PASSPORT = R.TFS<TFS.LOCAL.REF,Y.TFS.PASSPORT>
                Y.L.ACQD.CITIZEN = R.TFS<TFS.LOCAL.REF,Y.TFS.RNC.POS>
                Y.L.NEW.ID.CARD = R.TFS<TFS.LOCAL.REF,Y.TFS.NEW.CARD.POS>
                Y.L.OLD.ID.CARD = R.TFS<TFS.LOCAL.REF,Y.TFS.OLD.CARD.POS>
            END
    END CASE

    BEGIN CASE
        CASE Y.L.PASSPORT NE ''
            Y.OUT = 'Pasaporte'
        CASE Y.L.ACQD.CITIZEN NE ''
            Y.OUT = 'RNC'
        CASE Y.L.NEW.ID.CARD NE ''
            Y.OUT = 'Cedula Nueva'
        CASE Y.L.OLD.ID.CARD NE ''
            Y.OUT = 'Cedula Vieja'
        CASE OTHERWISE
            Y.OUT = ''
    END CASE

RETURN
END
