* @ValidationCode : Mjo4NjIzNzc2NzI6Q3AxMjUyOjE2OTgyMzcxOTg4NTc6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:03:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                NO CHANGES
*-----------------------------------------------------------------------------------------------------------------------------------
*    SUBROUTINE ITSS.MF.EXEC.REQUEST(ACTION.INFO, MOB.OFS.REQUEST, RESERVED.2, RESERVED.3, RESERVED.4, MOB.RESPONSE, MOB.ERROR)
    SUBROUTINE ITSS.MF.EXEC.REQUEST(ACTION.INFO, MOB.OFS.REQUEST, MOB.RESPONSE, MOB.ERROR)
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.SOURCE
    $INSERT I_EB.EXTERNAL.COMMON
*-----------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS.REQUEST


    RETURN

*-----------------------------------------------------------------------------
INITIALISE:

*   USER.NAME = EXT.USER.ID
    THE.REQUEST = MOB.OFS.REQUEST
    THE.RESPONSE = ''
    REQUEST.COM = ''

    RETURN

*-----------------------------------------------------------------------------
PROCESS.REQUEST:

    SAVE.CHANNEL = OFS$SOURCE.REC<OFS.SRC.CHANNEL>
    SAVE.SRC.TYPE = OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE>
    SAVE.SRC.ATTRIBUTES = OFS$SOURCE.REC<OFS.SRC.ATTRIBUTES>

*    CHANGE 'INTERFACE' TO '' IN OFS$SOURCE.REC<OFS.SRC.ATTRIBUTES>

*DEBUG
*  OFS$SOURCE.REC<OFS.SRC.CHANNEL> = 'INTERNET'
 *   OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> = 'SESSION'
    CALL OFS.BULK.MANAGER(THE.REQUEST, THE.RESPONSE, REQUEST.COM)
*    OFS$SOURCE.REC<OFS.SRC.ATTRIBUTES> = SAVE.SRC.ATTRIBUTES

*     SRC.ID = OFS$SOURCE.ID
*     SAVE.THE.REQUEST = THE.REQUEST
*     CALL OFS.GLOBUS.MANAGER(SRC.ID, THE.REQUEST)
*     THE.RESPONSE = THE.REQUEST
*     THE.REQUEST = SAVE.THE.REQUEST

 *  OFS$SOURCE.REC<OFS.SRC.CHANNEL> = SAVE.CHANNEL

  *  OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> = SAVE.SRC.TYPE

    IF THE.REQUEST[1,14] NE 'ENQUIRY.SELECT' THEN
        REQUEST.CHECK = REQUEST.COM
        IF THE.REQUEST[',',2,1]['/',3,1] EQ 'VALIDATE' THEN
            REQUEST.CHECK = 1
        END
        IF THE.RESPONSE[',',1,1]['/',3,1] EQ '1' THEN
            RESPONSE.CHECK =1
        END
        IF RESPONSE.CHECK THEN
            MOB.RESPONSE = THE.RESPONSE
        END ELSE
            MOB.ERROR = THE.RESPONSE
        END
    END ELSE
        MOB.RESPONSE = THE.RESPONSE
    END

    RETURN

*-----------------------------------------------------------------------------

END
