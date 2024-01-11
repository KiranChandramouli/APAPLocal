* @ValidationCode : Mjo2ODQxMDcyMTE6Q3AxMjUyOjE3MDQ4MDA4ODkyMjg6dmlnbmVzaHdhcmk6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 17:18:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS

*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.IVR.ENQ.REQ.RESP.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine EB.REDO.IVR.ENQ.REQ.RESP.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*DATE          AUTHOR                   Modification                            DESCRIPTION
*07-Nov-2023  Harishvikram C   Manual R22 conversion    Batch created for IVRInterfaceTWS Fix
*07/10/2023   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES            NOCHANGES
*07/11/2023   VIGNESHWARI        MANUAL R22 CODE CONVERSION              Insert file is commented
*09-01-2024   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES          SQA-12248 – By Santiago
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
*    $INSERT I_COMMON   ;*MANUAL R22 CODE CONVERSION
*   $INSERT I_EQUATE   ;*MANUAL R22 CODE CONVERSION
*  $INSERT I_DataTypes    ;*MANUAL R22 CODE CONVERSION
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Template
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    EB.Template.TableDefineid("@ID", T24_String)    ;*MANUAL R22 CODE CONVERSION


*-----------------------------------------------------------------------------


    EB.Template.TableAddfielddefinition("OFS.REQUEST","200", "TEXT" ,"") ;* Add a new fields
    EB.Template.TableAddfielddefinition("OFS.RESPONSE","200", "TEXT" ,"") ;* Add a new fields
    EB.Template.TableAddfielddefinition("PROCESSED","1", "A" ,"") ;* Add a new Reserved fields	;*Fix SQA-12248 – By Santiago-new line added
    EB.Template.TableAddreservedfield("RESERVED.4") ;* Add a new Reserved fields	;*Fix SQA-12248 – By Santiago-changed "RESERVED.1" to "RESERVED.4"
    EB.Template.TableAddreservedfield("RESERVED.3") ;* Add a new Reserved fields
    EB.Template.TableAddreservedfield("RESERVED.2") ;* Add a new Reserved fields	;*Fix SQA-12248 – By Santiago-changed "RESERVED.4" to "RESERVED.2"
    EB.Template.TableAddreservedfield("RESERVED.1") ;* Add a new Reserved fields	;*Fix SQA-12248 – By Santiago-changed "RESERVED.5" to "RESERVED.1"

    EB.Template.TableAddlocalreferencefield("") ;* Add a new Local Reference fields
    
    EB.Template.TableAddstatementnumbersfield("") ;* Add a statement numbers field
    EB.Template.TableAddoverridefield() ;* Add a new Override fields
*-----------------------------------------------------------------------------

    EB.Template.TableSetauditposition() ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
