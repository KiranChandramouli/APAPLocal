* @ValidationCode : MjotMzYwNzU5MzU3OkNwMTI1MjoxNjgyNDEyMzYzMTg0OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:03
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
$PACKAGE APAP.REDOVER
*
* Subroutine Type : VERSION ROUTINE
* Attached to     : ACCOUNT & AZ.ACCOUNT
* Attached as     : FIELD VALIDATION

SUBROUTINE REDO.V.VAL.NOTIFY
*----------------------------------------------------------------------------------------------------------------------
* DESCRIPTION
* -----------
* Routine to check the product notice were duplicated by the user
*----------------------------------------------------------------------------------------------------------------------
* Input / Output
*----------------------------------------------------------------------------------------------------------------------
* IN     :
* OUT    :
*----------------------------------------------------------------------------------------------------------------------
* Dependencies
*----------------------------------------------------------------------------------------------------------------------
* CALLS     :
* CALLED BY :
*
* CHANGE REQUEST / DEVELOPMENT REF:
*----------------------------------------------------------------------------------------------------------------------
* Revision History
*----------------------------------------------------------------------------------------------------------------------
* Date          Developed By            Reference       Description
*
* 08/02/2013    Vignesh Kumaar M R                      Initial Version
* 12/03/2013    Vignesh Kumaar M R      PACS00253693    Override Msg for Account Notify
*
*----------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM SM TO @SM
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_GTS.COMMON

    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT

    IF MESSAGE NE 'VAL' AND COMI NE '' THEN
        GOSUB NOTIFY.VALIDATE
    END

RETURN

*----------------------------------------------------------------------------------------------------------------------
NOTIFY.VALIDATE:
*----------------------------------------------------------------------------------------------------------------------

    LREF.APP = APPLICATION
    LREF.FIELD = 'L.AC.NOTIFY.1'

    GOSUB GET.LRF.POS
    L.AC.NOTIFY.1.POS = LREF.POS<1,1>

    IF APPLICATION EQ 'ACCOUNT' THEN
        GET.NOTIFY.ARR = R.NEW(AC.LOCAL.REF)<1,L.AC.NOTIFY.1.POS>
        AF = AC.LOCAL.REF
    END

    IF APPLICATION EQ 'AZ.ACCOUNT' THEN
        GET.NOTIFY.ARR = R.NEW(AZ.LOCAL.REF)<1,L.AC.NOTIFY.1.POS>
        AF = AZ.LOCAL.REF
    END

    CHANGE @SM TO @FM IN GET.NOTIFY.ARR

    LOCATE COMI IN GET.NOTIFY.ARR<1,1> SETTING NOTIFY.POS THEN
        COMI = ''
        AV = L.AC.NOTIFY.1.POS
        ETEXT = 'EB-REDO.NOTIFY.ALREADY.EXIST'
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------------------------------------------------------
GET.LRF.POS:
*----------------------------------------------------------------------------------------------------------------------

    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)

RETURN

*----------------------------------------------------------------------------------------------------------------------
END
