*********************************************************************
* Licensed Materials - Property of IBM                              *
* (c) Copyright IBM Corporation 2009, 2017. All Rights Reserved.    *
*                                                                   *
* Note to U.S. Government Users Restricted Rights:                  *
* Use, duplication or disclosure restricted by GSA ADP Schedule     *
* Contract with IBM Corp.                                           *
*********************************************************************
         COPY ASMMSP                    * FOR SPM
*                                       * (STRUCTURED
*                                       *  PROGRAMMING
*                                       *  MACRO)
*
*********************************************************************
*  Allocate buffer using STORAGE OBTAIN macro                       *
*********************************************************************
*INPUTS:                                                            *
*  PARMS -                                                          *
*    len    - Length of buffer to be allocated.                     *
*********************************************************************
*OUTPUTS:                                                           *
*   RETURN CODES -                                                  *
*      0 - failure.                                                 *
*     others - Allocated buffer address                             *
*********************************************************************
BLZTEST1 EDCXPRLG PARMWRDS=1,BASEREG=R11,DSASIZE=CEEDSAHPSZ+WKSIZE
         USING DSA,R4

         LR    R7,R1
         LR    R8,R3

         MVC   RACRTLST(RACRTL),RACRT   * COPY RACROUTE MACRO
         RACROUTE REQUEST=AUTH,ENTITY=((R7)),VOLSER=(R2),              X
               WORKA=RACWK,LOG=NOSTAT,STATUS=ACCESS,                   X
               RELEASE=1.9,MF=(E,RACRTLST)

         USING SAFP,R5                  * RACROUTE parameter list
         LA    R5,RACRTLST
         L     R2,SAFPRRET              * RACF return code
         L     R3,SAFPRREA              * RACF reason code

         USING RCBUF,R8
         ST    R2,RETCODE
         ST    R3,REASON

         LR    R3,R15                   * RESTORE RC FROM RACROUTE

         EDCXEPLG

         LTORG

RACRT    RACROUTE REQUEST=AUTH,CLASS='DATASET',STATUS=ACCESS,          X
               RACFIND=YES,LOG=NOSTAT,RELEASE=1.9,MF=L
RACRTL   EQU *-RACRT

         ICHSAFP

DSA      CEEDSA SECTYPE=XPLINK      .Mapping of the Dynamic Save Area
         ORG CEEDSAHP_ARGLIST
RACRTLST RACROUTE REQUEST=AUTH,CLASS='DATASET',STATUS=ACCESS,          X
               RACFIND=YES,LOG=NOSTAT,RELEASE=1.9,MF=L
RACWK    DS CL512
WKSIZE   EQU   *-RACRTLST
*
         CEECAA  ,                  .Mapping of the Common Anchor Area
*
RCBUF    DSECT
RETCODE  DS    F
REASON   DS    F
*                                       * AREA
*********************** REGISTERS *************************************
R0       EQU   0
R1       EQU   1
R2       EQU   2
R3       EQU   3
R4       EQU   4
R5       EQU   5
R6       EQU   6
R7       EQU   7
R8       EQU   8
R9       EQU   9
R10      EQU   10
R11      EQU   11
R12      EQU   12
R13      EQU   13
R14      EQU   14
R15      EQU   15
         END   BLZTEST1
