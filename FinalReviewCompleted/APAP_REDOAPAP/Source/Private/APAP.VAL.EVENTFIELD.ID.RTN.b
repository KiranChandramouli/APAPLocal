* @ValidationCode : Mjo5MDc5NTU3MDg6Q3AxMjUyOjE2ODQ4MzYwMzI0MDE6SVRTUzotMTotMTo2MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 63
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.VAL.EVENTFIELD.ID.RTN
* ====================================================================================
*
*    - this routine gives a Behaviour for fields
*
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose : gives a Behaviour for fields
*
*
* Incoming:
* ---------
* NA
*
*
* Outgoing:
* ---------
* NA
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Cristhian Herrera
* Date            :
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.EVENTFIELD

*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
* ======
PROCESS:
* ======
    APP.NAME=APPLICATION

    IF ID.NEW NE VALID.ID THEN
        ETEXT = "EB-B2-PARAMS.EVENTFIELD"
        CALL STORE.END.ERROR
    END

RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.EVENTFIELD,F.EVENTFIELD)

RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1


        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT        =  0
    MAX.LOOPS       =  0
    PROCESS.GOAHEAD =  1

    APP.NAME        =  ''
    Y.APP.ERR       =  ''

    FN.EVENTFIELD =  'F.APAP.H.INSURANCE.EVENTFIELD'
    F.EVENTFIELD  =  ''
    R.EVENTFIELD  =  ''

    VALID.ID      = 'MANAGEMENT.TYPE'


RETURN

END
