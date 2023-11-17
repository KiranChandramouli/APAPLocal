* @ValidationCode : MjotMTA4MDI5OTI2NDpDcDEyNTI6MTY4NDIyMjgzNDc0MTpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             T24.BP Removed in Insert File
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.S.RTE.DOC.NUMBER(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.DOC.NUMBER
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the Document Number value
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON
    $INSERT I_F.TELLER ;*AUTO R22 CODE CONVERSION - END

    GOSUB PROCESS
RETURN
*********
PROCESS:
*********

    LRF.APP = "TELLER"
    LRF.FIELD = "L.TT.LEGAL.ID"
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)

    TT.LEGAL.POS = LRF.POS<1,1>

    BEGIN CASE

        CASE VAR.PASSPORT NE ''
            Y.OUT = VAR.PASSPORT
        CASE VAR.RNC NE ''
            Y.OUT = VAR.RNC
        CASE VAR.CEDULA NE ''
            Y.OUT = VAR.CEDULA
        CASE OTHERWISE
            IF ID.NEW[1,2] EQ 'TT' THEN
                Y.TT.LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,TT.LEGAL.POS>
                IF Y.TT.LEGAL.ID NE '' THEN
                    Y.OUT = FIELD(Y.TT.LEGAL.ID,'.',2)
                END ELSE
                    Y.OUT = ''
                END
            END ELSE
                Y.OUT = ''
            END
    END CASE

RETURN
END
