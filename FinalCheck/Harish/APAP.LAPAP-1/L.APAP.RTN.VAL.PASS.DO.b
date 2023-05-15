$PACKAGE APAP.LAPAP
* Technical report:
* -----------------
* Company Name   : APAP
* Program Name   : L.APAP.RTN.VAL.PASS.DO
* Author         : Raquel P. S.
* Item ID        : CN009180
*-------------------------------------------------------------------------------------
* Description :
* ------------
* This program allow verify the ID against the T24 table (Only cedula and  RNC)
*-------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018/03/29     Raquel P. S.        Initial development
*-------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Table name     :
* Auto Increment :
* Views/versions : Version REDO.ID.CARD.CHECK,
* PGM record      : L.APAP.RTN.VAL.PASS.DO
* DependentRoutines :
*------------------------------------------------------------------------------------


SUBROUTINE L.APAP.RTN.VAL.PASS.DO
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.CUSTOMER

    Y.IDENTITY.TYPE=R.NEW(REDO.CUS.PRF.IDENTITY.TYPE)
    Y.PASSPORT.COUNTRY=R.NEW(REDO.CUS.PRF.PASSPORT.COUNTRY)

    IF Y.IDENTITY.TYPE EQ 'PASAPORTE' AND Y.PASSPORT.COUNTRY EQ 'DO' THEN
        ETEXT='PARA DOMINICANOS, EL DOCUMENTO PERMITIDO ES LA CEDULA'
        CALL STORE.END.ERROR
        RETURN
    END


* Previous routine called in field Validation Rtn.4 before this change

    CALL REDO.V.CHECK.PASSPORT.COUNTRY
RETURN

END
