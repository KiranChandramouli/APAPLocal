* @ValidationCode : Mjo0NTQ1NDg2OTU6Q3AxMjUyOjE2ODA5NDA3MTMxMTA6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Apr 2023 13:28:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.R.MULTI.GET.FIELD.NO(P.APPLICATION,P.FIELD.NAME, R.STANDARD.SELECTION, P.FIELD.NO)
*-----------------------------------------------------------------------------
*
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package REDO.AA
* This routines allows to get a field number for the given application and field names
*
* Parameters
* ------------------
* P.APPLICATION (in) It must be a valid entry from STANDARD.SELECTION
* P.FIELD.NAME (in) The list of fields' names to be searched
* R.STANDARD.SELECTION (in) Standard Selection record. optional. If left blank, the routine try to load it
* P.FIELD.NO (out) The list of fields' numbers found,
* If the field was not found then an emtpy entry was returned
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, I TO I.VAR
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDARD.SELECTION
*-----------------------------------------------------------------------------


    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*
    IF R.STANDARD.SELECTION EQ '' THEN
        CALL GET.STANDARD.SELECTION.DETS( P.APPLICATION, R.STANDARD.SELECTION )
    END
    Y.TOT.FIELDS = DCOUNT(P.FIELD.NAME,@FM)
    FOR I.VAR=1 TO Y.TOT.FIELDS                     ;** R22 Auto conversion - I TO I.VAR
        FIELD.NAME = P.FIELD.NAME<I.VAR>            ;** R22 Auto conversion - I TO I.VAR
        FIELD.NO = ''
        GOSUB FIND.FIELD
        P.FIELD.NO<I.VAR> = FIELD.NO                  ;** R22 Auto conversion - I TO I.VAR
    NEXT I.VAR                                        ;** R22 Auto conversion - I TO I.VAR
RETURN
*-----------------------------------------------------------------------------
FIND.FIELD:
*-----------------------------------------------------------------------------
    FIELD.NO = ''
    NOT.FINISHED = 1
    LOCATE FIELD.NAME IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING FOUND.POS THEN
        LOOP
        WHILE NOT.FINISHED
            BEGIN CASE
                CASE NUM(R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,FOUND.POS>) ;* Points to a field
                    FIELD.NO = R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,FOUND.POS>
                    NOT.FINISHED = ''
                CASE OTHERWISE
*< APAP - B.5
                    IF NOT(FIELD.NO) THEN
                        CALL GET.LOC.REF(P.APPLICATION,FIELD.NAME,FIELD.NO)

                    END
*> APAP - B.5
                    FIELD.NAME = R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,FOUND.POS>
            END CASE
            LOCATE FIELD.NAME IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING FOUND.POS ELSE
                NOT.FINISHED = ''
            END
        REPEAT
    END


RETURN
*-----------------------------------------------------------------------------
END
