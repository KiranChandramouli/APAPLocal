SUBROUTINE REDO.RAD.MON.RESIDENCESN

*-----------------------------------------------------------------------------
* Primary Purpose: Returns S if the param received belongs to local country, else returns N
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: COUNTRY_OF_RESIDENCE
* Output Parameters: S (Resident) or N (No Resident)
*-----------------------------------------------------------------------------
* Modification History:
*
* 18/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_TSS.COMMON
    $INSERT I_F.COMPANY

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
    BEGIN CASE
        CASE Y.PARAM EQ Y.LOCAL.COUNTRY
            Y.RETURN = 'SI'
        CASE OTHERWISE
            Y.RETURN = 'NO'
    END CASE

    COMI = Y.RETURN

RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------

*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:
    PROCESS.GOAHEAD = 1
    IP.ADDRESS = TSS$CLIENTIP
    Y.INTERF.ID = 'MON001'
    Y.RETURN = ''
    Y.RESIDENCE.S = 'S'
    Y.RESIDENCE.N = 'N'
    ERR.MSG = ''
    ERR.TYPE = ''
    Y.LOCAL.COUNTRY = R.COMPANY(EB.COM.LOCAL.COUNTRY)

    Y.PARAM = COMI


RETURN
*-----------------------------------------------------------------------------------

OPEN.FILES:


RETURN

*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

RETURN

*-----------------------------------------------------------------------------------

END
