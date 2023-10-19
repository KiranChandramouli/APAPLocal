$PACKAGE APAP.TAM
* @ValidationCode : Mjo4ODE0Nzg4MTU6Q3AxMjUyOjE2ODEzNzI0NjI4MjE6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:24:22
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
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
