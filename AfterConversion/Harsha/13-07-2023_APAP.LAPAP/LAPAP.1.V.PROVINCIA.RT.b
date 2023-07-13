* @ValidationCode : MjotMTY3NTk5MjU2MjpDcDEyNTI6MTY4OTIyNjI5Mzk1NzpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jul 2023 11:01:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.1.V.PROVINCIA.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.MOD.DIRECCIONES
    $INSERT I_F.ST.LAPAP.RD.PROVINCES


    IF R.NEW(ST.MDIR.PAIS) EQ 'DO' THEN
        FN.PROVINCE = "F.ST.LAPAP.RD.PROVINCES"
        F.PROVINCE = ""
        CALL OPF(FN.PROVINCE,F.PROVINCE)

        Y.VALUE = COMI
        Y.ID.PROVINCIA = EREPLACE(Y.VALUE," ",".")

        IF Y.VALUE EQ '' THEN
            ETEXT = "ESTE CAMPO ES MANDATORIO CUANDO EL PAIS ES REP. DOMINICANA (DO)."
            CALL STORE.END.ERROR
            RETURN
        END
        CALL F.READ(FN.PROVINCE,Y.ID.PROVINCIA,R.PROVINCES,F.PROVINCE,ERR.PROVINCES)

        IF ERR.PROVINCES NE '' THEN
            ETEXT = "INDIQUE UNO DE LOS POSIBLE VALORES DE LA LISTA PARA EL CAMPO PROVINCIA."
            CALL STORE.END.ERROR
            RETURN
        END


    END
RETURN

END
