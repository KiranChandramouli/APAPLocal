* @ValidationCode : MjoxNTcxNDgzNjk4OkNwMTI1MjoxNjg0MjIyODA2NTMwOklUU1M6LTE6LTE6OTY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 96
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*                   T E C H N I C A L  R E Q U E R I M E N T
*--------------------------------------------------------------------------------------
* Validate the local field LOCAL.REF-49, in case that to be marked we going to procced
* to obligate the user select one of the possible values in the below dropdown
*=====================================================================================

*-------------------------------------------------------------------------------------
SUBROUTINE LAPAP.CUS.REDO.INFO.ADI.PF.VAL
*-------------------------------------------------------------------------------------
* Technical report:
* -----------------
* Company Name   : APAP
* Program Name   : LAPAP.CUS.REDO.INFO.ADI.PF.VAL
* Date           : 2017-09-26
* Author         : RichardHC
* Item ID        : CN006607
*-------------------------------------------------------------------------------------
* Description :
* ------------
* This program allow validate if radiobutton local field is marked
*-------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
*
*-------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Table name     : unknown
* Auto Increment : unknown
* Views/versions : unknown
* EB record      :
* Routines       :
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     <> TO NE
*21-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*-------------------------------------------------------------------------------------

*Importing the neccessary libraries and tables.
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
   $USING EB.LocalReferences

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)


*Capturing data from browser
    VAR.CUS.STATUS = COMI

*    CALL GET.LOC.REF("CUSTOMER","L.APAP.TOD.D",CUS.POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.APAP.TOD.D",CUS.POS);* R22 UTILITY AUTO CONVERSION
    VAR.CUS.DISC = R.NEW(EB.CUS.LOCAL.REF)<1,CUS.POS>

*Validating the first local value got with COMI
    IF VAR.CUS.STATUS EQ 'SI' AND VAR.CUS.DISC EQ '' THEN

        ETEXT = "INDIQUE EL TIPO DE DISCAPACIDAD"

        CALL STORE.END.ERROR


    END

*validating the second local value got with the previous method to obtention
    IF VAR.CUS.STATUS EQ 'NO' AND VAR.CUS.DISC NE '' THEN

        ETEXT = "VERIFIQUE LA INFORMACION INDICADA COMO NO Y QUE SIN EMBARGO SUMINISTRO EN EL CAMPO MAS ABAJO"

        CALL STORE.END.ERROR


    END

*validating the second local value got with the previous method to obtention
    IF VAR.CUS.STATUS NE 'NO' AND  VAR.CUS.STATUS NE 'SI' AND VAR.CUS.DISC NE '' THEN

        ETEXT = "DEBE TAMBIEN INDICAR SI O NO"

        CALL STORE.END.ERROR


    END

RETURN

END
