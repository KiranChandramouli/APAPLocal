SUBROUTINE REDO.CONV.ENQ.GROUP
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.INP.CHQ.ISS
* ODR NO      : ODR-2009-12-0275
*----------------------------------------------------------------------
*DESCRIPTION: Conversion routine for the Enquiry REDO.H.CANT.CK.PF


*IN PARAMETER:NONE
*OUT PARAMETER:NONE
*LINKED WITH: REDO.H.SOLICITUD.CK
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*19.02.2010  H GANESH     ODR-2009-12-0275  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER

*-----------------------------------------------------------------------

    VIRTUAL.TAB.ID='L.TT.GROUP'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC
    Y.GROUP.VALUE = O.DATA
    LOCATE Y.GROUP.VALUE IN Y.LOOKUP.LIST SETTING POS1 THEN
        IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN          ;* This is for english user
            O.DATA=Y.LOOKUP.DESC<POS1,1>
        END
        IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
            O.DATA=Y.LOOKUP.DESC<POS1,2>      ;* This is for spanish user
        END ELSE
            O.DATA=Y.LOOKUP.DESC<POS1,1>
        END
    END

RETURN
END
