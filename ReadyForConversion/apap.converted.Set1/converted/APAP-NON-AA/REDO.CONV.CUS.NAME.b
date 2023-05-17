SUBROUTINE REDO.CONV.CUS.NAME
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION :
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.NOFILE.REFERENCE
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 17-Aug-2010      Naveenkumar N      ODR-2010-08-0470            Initial creation
*--------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.RESTRICTIVE.LIST
*

    GOSUB PROCESS
RETURN
********
PROCESS:
********
    Y.TIPO.DE.PERSONA = R.RECORD<RESTR.LIST.TIPO.DE.PERSONA>
    IF Y.TIPO.DE.PERSONA EQ "PERSONA FISICA" OR Y.TIPO.DE.PERSONA EQ "PERSONA.FISICA" THEN  ;* PACS00311526 - 13/APR/2015 - S
        Y.NOMBRES   = R.RECORD<RESTR.LIST.NOMBRES>
        Y.APELLIDOS = R.RECORD<RESTR.LIST.APELLIDOS>
        Y.CUS.NAME  = Y.NOMBRES:' ':Y.APELLIDOS       ;* Separate customer name from Famliy name. PACS00311526
        O.DATA = Y.CUS.NAME
    END
    IF Y.TIPO.DE.PERSONA EQ "PERSONA JURIDICA" OR Y.TIPO.DE.PERSONA EQ "PERSONA.JURIDICA" THEN        ;* PACS00311526 - 13/APR/2015 - E
        Y.CUS.NAME  = R.RECORD<RESTR.LIST.RAZON.SOCIAL>
        O.DATA = Y.CUS.NAME
    END
RETURN
END
