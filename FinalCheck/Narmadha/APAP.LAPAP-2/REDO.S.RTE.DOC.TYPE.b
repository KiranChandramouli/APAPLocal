* @ValidationCode : MjozMjgzNjUxMDY6Q3AxMjUyOjE2ODI0MDY4MTA5NjY6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 12:43:30
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
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          T24.BP Removed in Insert File
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.S.RTE.DOC.TYPE(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.DOC.TYPE
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the Document Type value
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
            Y.OUT = 'Pasaporte'
        CASE VAR.RNC NE ''
            Y.OUT = 'RNC'
        CASE VAR.CEDULA NE ''
            Y.OUT = 'Cedula'
        CASE OTHERWISE
            IF ID.NEW[1,2] EQ 'TT' THEN
                Y.TT.LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,TT.LEGAL.POS>
                IF Y.TT.LEGAL.ID NE '' THEN
                    Y.OUT = FIELD(Y.TT.LEGAL.ID,'.',1)
                END ELSE
                    Y.OUT = ''
                END
            END ELSE
                Y.OUT = ''
            END
    END CASE

RETURN
END
